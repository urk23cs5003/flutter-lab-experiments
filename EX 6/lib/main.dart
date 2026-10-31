
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart' as p;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for Chrome or desktop.
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Records',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const StudentRecordsPage(),
    );
  }
}

class StudentRecordsPage extends StatefulWidget {
  const StudentRecordsPage({super.key});

  @override
  State<StudentRecordsPage> createState() =>
      _StudentRecordsPageState();
}

class _StudentRecordsPageState
    extends State<StudentRecordsPage> {

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _registerController =
      TextEditingController();

  final TextEditingController _departmentController =
      TextEditingController();

  Database? database;

  List<Map<String, dynamic>> students = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  // CREATE DATABASE AND TABLE
  Future<void> initializeDatabase() async {
    try {
      final String dbPath = kIsWeb
          ? 'students_web.db'
          : p.join(await getDatabasesPath(), 'students.db');
      database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE students (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              registerNumber TEXT NOT NULL,
              department TEXT NOT NULL
            )
          ''');
        },
      );

      await loadStudents();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Database error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // READ STUDENT RECORDS
  Future<void> loadStudents() async {
    if (database == null) return;

    final records = await database!.query(
      'students',
      orderBy: 'id DESC',
    );

    if (!mounted) return;

    setState(() {
      students = records;
    });
  }

  // INSERT STUDENT RECORD
  Future<void> addStudent() async {
    final String name = _nameController.text.trim();
    final String registerNumber =
        _registerController.text.trim();
    final String department =
        _departmentController.text.trim();

    if (name.isEmpty ||
        registerNumber.isEmpty ||
        department.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    if (database == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database is not ready'),
        ),
      );
      return;
    }

    try {
      await database!.insert(
        'students',
        {
          'name': name,
          'registerNumber': registerNumber,
          'department': department,
        },
      );

      _nameController.clear();
      _registerController.clear();
      _departmentController.clear();

      await loadStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving student: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Records'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [

                const Text(
                  'Student Registration',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                // STUDENT NAME
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    hintText: 'Enter student name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // REGISTER NUMBER
                TextField(
                  controller: _registerController,
                  decoration: const InputDecoration(
                    labelText: 'Register Number',
                    hintText: 'Enter register number',
                    prefixIcon: Icon(Icons.badge),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // DEPARTMENT
                TextField(
                  controller: _departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    hintText: 'Enter department',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                // SAVE BUTTON
                ElevatedButton.icon(
                  onPressed: isLoading ? null : addStudent,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Student'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 15),

                const Text(
                  'Saved Student Records',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (students.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No student records found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: students.length,

                    itemBuilder: (context, index) {
                      final student = students[index];

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),

                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),

                          title: Text(
                            student['name'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            'Register No: '
                            '${student['registerNumber']}\n'
                            'Department: '
                            '${student['department']}',
                          ),

                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _registerController.dispose();
    _departmentController.dispose();
    database?.close();
    super.dispose();
  }
}
