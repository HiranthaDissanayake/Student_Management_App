import 'package:flutter/material.dart';
import 'package:student_manager/Models/student_model.dart';
import 'package:student_manager/Services/api_service.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student List")),
      body: FutureBuilder<List<Student>>(
        future: apiService.getAllStudents(), // මෙතනදී API එක call කරනවා
        builder: (context, snapshot) {
          // 1. Data එනකම් Loading එකක් පෙන්වනවා
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          // 2. මොකක් හරි error එකක් ආවොත් ඒක පෙන්වනවා
          else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } 
          // 3. Data සාර්ථකව ලැබුනම List එකක් විදිහට පෙන්වනවා
          else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final student = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(child: Text(student.name[0])),
                  title: Text(student.name),
                  subtitle: Text("ID: ${student.studentId} | Age: ${student.age}"),
                  trailing: Icon(Icons.phone, size: 18),
                );
              },
            );
          } 
          else {
            return Center(child: Text("දත්ත කිසිවක් නැත!"));
          }
        },
      ),
    );
  }
}