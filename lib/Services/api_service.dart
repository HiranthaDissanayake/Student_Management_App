import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_manager/Models/student_model.dart';

class ApiService {
  // Static methods වලදී භාවිතා කිරීමට baseUrl එකද static විය යුතුය
  static const String baseUrl = "http://10.208.40.38:8080/api/v1";

  // 1. GET Request
  Future<List<Student>> getAllStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getusers'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Student.fromJson(item)).toList();
      } else {
        throw "Failed to load students";
      }
    } catch (e) {
      throw "Error: $e";
    }
  }

  // 2. POST Request - මෙහිදී bool අගයක් return කරයි
  static Future<bool> addStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/adduser'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(student.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("සාර්ථකව ඇතුළත් කළා!");
        return true; // මෙතනදී true ලබා දෙයි
      } else {
        print("Backend Error: ${response.statusCode}");
        return false; // අසාර්ථක නම් false ලබා දෙයි
      }
    } catch (e) {
      print("Connection Error: $e");
      return false; // Connection error එකකදී false ලබා දෙයි
    }
  }
}