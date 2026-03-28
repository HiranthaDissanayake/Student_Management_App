import 'package:flutter/material.dart';
import 'package:student_manager/Models/student_model.dart';
import 'package:student_manager/Services/api_service.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final ApiService apiService = ApiService();

  void deleteStudent(int id) async {
    bool success = await ApiService.deleteStudent(id);
    if (success) {
      setState(() {}); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student Deleted!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  
  void showEditPopup(Student student) {
    
    TextEditingController nameController = TextEditingController(
      text: student.name,
    );
    TextEditingController ageController = TextEditingController(
      text: student.age.toString(),
    );
    TextEditingController studentIdController = TextEditingController(
      text: student.studentId,
    );
    TextEditingController phoneController = TextEditingController(
      text: student.phone,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(
            context,
          ).viewInsets.bottom, 
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Edit Student Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: studentIdController,
              decoration: const InputDecoration(labelText: "Student ID"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                
                Student updatedStudent = Student(
                  id: student.id, 
                  name: nameController.text,
                  age: int.parse(ageController.text),
                  studentId: studentIdController.text,
                  phone: phoneController.text,
                );

                
                bool success = await ApiService.updateStudent(updatedStudent);
                if (success) {
                  Navigator.pop(context); 
                  setState(() {}); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Student Updated Successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text("Update Details"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

 
  void showStudentDetails(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Database ID: ${student.id}"),
            Text("Student ID: ${student.studentId}"),
            Text("Age: ${student.age}"),
            Text("Phone: ${student.phone}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Student>>(
        future: apiService.getAllStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("දත්ත කිසිවක් නැත!"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final student = snapshot.data![index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      student.name[0],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  title: Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("ID: ${student.studentId}"),
                  onTap: () => showStudentDetails(student), 
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          showEditPopup(student); 
                        },
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete?"),
                              content: const Text(
                                "Are you sure you want to delete this student?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteStudent(student.id!);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
