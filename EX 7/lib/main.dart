
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController registerController =
      TextEditingController();

  final TextEditingController departmentController =
      TextEditingController();

  // Firestore database reference
  final CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  bool isSaving = false;

  // CREATE OPERATION
  Future<void> addStudent() async {
    String name = nameController.text.trim();
    String registerNumber =
        registerController.text.trim();
    String department =
        departmentController.text.trim();

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

    setState(() {
      isSaving = true;
    });

    try {
      await students.add({
        'name': name,
        'registerNumber': registerNumber,
        'department': department,
        'createdAt': FieldValue.serverTimestamp(),
      });

      nameController.clear();
      registerController.clear();
      departmentController.clear();

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
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
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
                  controller: nameController,
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
                  controller: registerController,
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
                  controller: departmentController,
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
                  onPressed: isSaving ? null : addStudent,
                  icon: const Icon(Icons.save),
                  label: Text(
                    isSaving ? 'Saving...' : 'Save Student',
                  ),
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

                // READ OPERATION
                StreamBuilder<QuerySnapshot>(
                  stream: students
                      .orderBy(
                        'createdAt',
                        descending: true,
                      )
                      .snapshots(),

                  builder: (context, snapshot) {

                    if (snapshot.hasError) {
                      return Text(
                        'Error loading records: ${snapshot.error}',
                      );
                    }

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
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
                      );
                    }

                    final records = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: records.length,

                      itemBuilder: (context, index) {
                        final student =
                            records[index].data()
                                as Map<String, dynamic>;

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
                              student['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              'Register No: '
                              '${student['registerNumber'] ?? ''}\n'
                              'Department: '
                              '${student['department'] ?? ''}',
                            ),

                            isThreeLine: true,
                          ),
                        );
                      },
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
    nameController.dispose();
    registerController.dispose();
    departmentController.dispose();
    super.dispose();
  }
}
