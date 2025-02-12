import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_admission/widget/smart_textfield.dart';
import 'homepage.dart';
class status extends StatefulWidget {
  const status({super.key});

  @override
  State<status> createState() => _statusState();
}

class _statusState extends State<status> {

  List<Map<String, dynamic>> studentData = [];
  List<Map<String, dynamic>> universityData = [];
  @override
  void initState() {
    // TODO: implement initState
    getStudents();
    super.initState();
  }
  String searchQuery = "";
  TextEditingController search_controller = TextEditingController();


  //Suggest University
  Future<void> fetchSuggestedUniversities(String CGPA, String sub1, String sub2, String sub3, String GPA1, String GPA2, String GPA3) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'action': 'suggestion',
          'CGPA': CGPA,
          'Subject_01' : sub1,
          'Subject_02' : sub2,
          'Subject_03' : sub3,
          'Subject_01_GPA': GPA1,
          'Subject_02_GPA': GPA2,
          'Subject_03_GPA': GPA3,
        },
      );

      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          universityData = List<Map<String, dynamic>>.from(responseData['data']);
        });
      } else {
        print("No matching universities found.");
      }
    } catch (e) {
      print("Error fetching universities: $e");
    }
  }



  //Update Data
  Future<void> updateStudent(String id, String cgpa, String subject1GPA, String subject2GPA, String subject3GPA) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'action': 'update',
          'ID': id,
          'CGPA': cgpa,
          'Subject_01_GPA': subject1GPA,
          'Subject_02_GPA': subject2GPA,
          'Subject_03_GPA': subject3GPA,
        },
      );

      print("Update Response: '${response.body}'");  // Debugging

      if (response.body.isEmpty) {
        print("Error: Server returned an empty response.");
        return;
      }

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse["status"] == "success") {
        getStudents();  // Refresh UI
      } else {
        print("Error: ${jsonResponse['message']}");
      }
    } catch (e) {
      print("Problem in updateStudent: $e");
    }
  }


  // Delete Data
  Future<void> deleteStudent(String id) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'action': 'delete',
        'ID': id,
      },
    );
    print(response.body);
  }


  // Read Data
  Future<void> getStudents() async {
    try {
      var response = await http.post(Uri.parse(apiUrl), body: {'action': 'read'});
      setState(() {
        studentData = List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
      });
    } catch (e) {
      print("Problem in getStudents: $e");
    }
  }

  List<Map<String, dynamic>> get filteredStudents {
    if (searchQuery.isEmpty) {
      return studentData;
    } else {
      return studentData.where((data) {
        return data['Name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            data['ID'].contains(searchQuery);
      }).toList();
    }
  }

  // Show Update Dialog
  void showUpdateDialog(Map<String, dynamic> student) {
    TextEditingController cgpaController = TextEditingController(text: student['CGPA'].toString());
    TextEditingController sub1GPAController = TextEditingController(text: student['Subject_01_GPA'].toString());
    TextEditingController sub2GPAController = TextEditingController(text: student['Subject_02_GPA'].toString());
    TextEditingController sub3GPAController = TextEditingController(text: student['Subject_03_GPA'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Student Result", textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SmartTextfield(hintText: "CGPA", controller: cgpaController),
                SizedBox(height: 10),
                SmartTextfield(hintText: "Top Subject-1 GPA", controller: sub1GPAController),
                SizedBox(height: 10),
                SmartTextfield(hintText: "Top Subject-2 GPA", controller: sub2GPAController),
                SizedBox(height: 10),
                SmartTextfield(hintText: "Top Subject-3 GPA", controller: sub3GPAController),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    updateStudent(student['ID'].toString(), cgpaController.text, sub1GPAController.text, sub2GPAController.text, sub3GPAController.text);
                    Navigator.pop(context);
                  },
                  child: const Text("Update Result", style: TextStyle(fontSize: 20, color: Colors.indigo)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void fresh(){

  }



  void showUniversities(List<Map<String, dynamic>> universities) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Can be Apply...", textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text("Institute Name")),
                DataColumn(label: Text("Subject")),
                DataColumn(label: Text("Seat")),
              ],
              rows: universities.map((universityData) {
                return DataRow(cells: [
                  DataCell(Text(universityData['Institute'].toString())),
                  DataCell(Text(universityData['Subject'].toString())),
                  DataCell(Text(universityData['Seat'].toString())),
                ]);
              }).toList(), // Convert the map to a list
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search by Name or ID',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Birthday')),
                  DataColumn(label: Text('CGPA')),
                  DataColumn(label: Text('Subject-1')),
                  DataColumn(label: Text('GPA')),
                  DataColumn(label: Text('Subject-2')),
                  DataColumn(label: Text('GPA')),
                  DataColumn(label: Text('Subject-3')),
                  DataColumn(label: Text('GPA')),
                  DataColumn(label: Text('Update Result')),
                  DataColumn(label: Text('Delete')),
                  DataColumn(label: Text(' ')),
                ],
                rows: filteredStudents.map((studentData) {
                  return DataRow(cells: [
                    DataCell(Text(studentData['ID'].toString())),
                    DataCell(Text("${studentData['Name']}")),
                    DataCell(Text("${studentData['BirthDay']}")),
                    DataCell(Text("${studentData['CGPA']}")),
                    DataCell(Text("${studentData['Subject_01']}")),
                    DataCell(Text("${studentData['Subject_01_GPA']}")),
                    DataCell(Text("${studentData['Subject_02']}")),
                    DataCell(Text("${studentData['Subject_02_GPA']}")),
                    DataCell(Text("${studentData['Subject_03']}")),
                    DataCell(Text("${studentData['Subject_03_GPA']}")),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.indigo),
                        onPressed: ()=>showUpdateDialog(studentData),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await deleteStudent(studentData['ID']);
                          getStudents();
                        },
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.spa, color: Colors.greenAccent),
                        onPressed: () async {
                            fetchSuggestedUniversities(studentData['CGPA'], studentData['Subject_01'], studentData['Subject_02'], studentData['Subject_03'], studentData['Subject_01_GPA'], studentData['Subject_02_GPA'], studentData['Subject_03_GPA']);
                            setState(() {
                              showUniversities(universityData);
                            });
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
