import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_admission/widget/smart_datepicker.dart';
import 'package:smart_admission/widget/smart_dropdown.dart';
import 'package:smart_admission/widget/smart_textfield.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

class signup_student extends StatefulWidget {
  const signup_student({super.key});

  @override
  State<signup_student> createState() => _signup_studentState();
}

class _signup_studentState extends State<signup_student> {

  Future<void> insertStudent(double cgpa, String sub1, double sub1gpa, String sub2, double sub2gpa, String sub3, double sub3gpa, String name, String birthday) async {
    try {
      var response = await http.post(Uri.parse(apiUrl), body: {
        'action': 'insert',
        'CGPA': cgpa.toString(),
        'Subject_01': sub1,
        'Subject_01_GPA': sub1gpa.toString(),
        'Subject_02': sub2,
        'Subject_02_GPA': sub2gpa.toString(),
        'Subject_03': sub3,
        'Subject_03_GPA': sub3gpa.toString(),
        'Name': name,
        'BirthDay': birthday,
      });
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Student added successfully!"),
      ));
    } catch (e) {
      print("Problem in insertStudent: $e");
    }
  }

  TextEditingController name_controller = TextEditingController();
  TextEditingController birth_controller = TextEditingController();
  TextEditingController cgpa_controller = TextEditingController();
  SmartDropdownController sub1_controller = SmartDropdownController();
  SmartDropdownController sub2_controller = SmartDropdownController();
  SmartDropdownController sub3_controller = SmartDropdownController();
  TextEditingController sub1GPA_controller = TextEditingController();
  TextEditingController sub2GPA_controller = TextEditingController();
  TextEditingController sub3GPA_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: Height,
          child: Column(
            children: [
              SizedBox(
                height: Height * 0.05,
              ),
              const Text("NEW STUDENT FORM"),
              SizedBox(
                height: Height * 0.05,
              ),
              SmartTextfield(hintText: "Name", controller: name_controller),
              SizedBox(
                height: Height * 0.01,
              ),
              SmartDatepicker(
                  hintText: "Date of Birth", controller: birth_controller),
              SizedBox(
                height: Height * 0.01,
              ),
              SmartTextfield(hintText: "CGPA", controller: cgpa_controller),
              SizedBox(
                height: Height * 0.01,
              ),
              SmartDropdown(labelText: "Top Subject 1", items: ["Bangla", "English", "Math", "ICT", "Biology", "Chemistry", "Marketing", "Arts"], controller: sub1_controller),
              SizedBox(
                height: Height * 0.01,
              ),
              SmartTextfield(
                  hintText: "Top Subject 01 GPA", controller: sub1GPA_controller),
              SizedBox(
                height: Height * 0.01,
              ),
              SmartDropdown(labelText: "Top Subject 2", items: ["Bangla", "English", "Math", "ICT", "Biology", "Chemistry", "Marketing", "Arts"], controller: sub2_controller),
              SizedBox(
                height: Height * 0.01,
              ),
              SmartTextfield(
                  hintText: "Top Subject 02 GPA", controller: sub2GPA_controller),
              SizedBox(
                height: Height * 0.01,
              ),
              SmartDropdown(labelText: "Top Subject 3", items: ["Bangla", "English", "Math", "ICT", "Biology", "Chemistry", "Marketing", "Arts"], controller: sub3_controller),
              SizedBox(
                height: Height * 0.01,
              ),
              SmartTextfield(
                  hintText: "Top Subject 03 GPA", controller: sub3GPA_controller),
              SizedBox(
                height: Height * 0.05,
              ),
              TextButton(onPressed: (){
                  insertStudent(double.parse(cgpa_controller.text), sub1_controller.value.toString(), double.parse(sub1GPA_controller.text), sub2_controller.value.toString(), double.parse(sub2GPA_controller.text), sub3_controller.value.toString(), double.parse(sub3GPA_controller.text), name_controller.text, birth_controller.text);
              }, child: Text("Submit", style: TextStyle(fontSize: 20, color: Colors.indigo),)),
              SizedBox(
                height: Height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
