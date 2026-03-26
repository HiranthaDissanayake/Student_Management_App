import 'package:flutter/material.dart';
import 'package:student_manager/Models/student_model.dart';
import 'package:student_manager/Pages/student_list_page.dart';
import '../services/api_service.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final student = Student(
      name: nameController.text,
      age: int.parse(ageController.text),
      studentId: idController.text,
      phone: phoneController.text,
    );

    // දැන් ApiService එකෙන් bool අගයක් ලැබේ
    bool success = await ApiService.addStudent(student);

    if (!mounted) return; // BuildContext එක තවමත් පවතිනවාදැයි පරීක්ෂාව

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Student Added Successfully!" : "Failed to Add Student"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      nameController.clear();
      ageController.clear();
      idController.clear();
      phoneController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: SingleChildScrollView( // Keyboard එක ආ විට overflow නොවීමට
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Student Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter age" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: idController,
                decoration: const InputDecoration(labelText: "Student ID"),
                validator: (v) => v!.isEmpty ? "Enter ID" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? "Enter phone" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("Add Student"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentListScreen()),
                  );
                },
                child: const Text("View All Students"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}