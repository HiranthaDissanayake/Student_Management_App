class Student {
  final int? id; 
  final String name;
  final int age;
  final String studentId;
  final String phone;

  Student({
    this.id, 
    required this.name,
    required this.age,
    required this.studentId,
    required this.phone,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      studentId: json['studentId'].toString(),
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id, 
      "name": name,
      "age": age,
      "studentId": studentId,
      "phone": phone,
    };
  }
}