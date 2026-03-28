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

    bool success = await ApiService.addStudent(student);

    if (!mounted) return;

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(success ? "Student Added Successfully!" : "Failed to Add Student"),
        backgroundColor: success ? Colors.greenAccent[700] : Colors.redAccent,
      ),
    );

    if (success) {
      nameController.clear();
      ageController.clear();
      idController.clear();
      phoneController.clear();
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Registration", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person_add, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: nameController,
                        decoration: _inputStyle("Full Name", Icons.person),
                        validator: (v) => v!.isEmpty ? "Enter name" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: ageController,
                        decoration: _inputStyle("Age", Icons.calendar_today),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? "Enter age" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: idController,
                        decoration: _inputStyle("Student ID", Icons.badge),
                        validator: (v) => v!.isEmpty ? "Enter ID" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: phoneController,
                        decoration: _inputStyle("Phone Number", Icons.phone),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v!.isEmpty ? "Enter phone" : null,
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: isLoading ? null : submit,
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00b09b), Color(0xFF96c93d)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "REGISTER NOW",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StudentListScreen()),
                  );
                },
                icon: const Icon(Icons.list_alt, color: Colors.white),
                label: const Text(
                  "View Registered Students",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}