import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_admission/signup_student.dart';
import 'package:smart_admission/status.dart';
import 'package:smart_admission/widget/smart_drawer.dart';

const String apiUrl = "http://localhost/myWeb/Student.php";


class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  int selected_screen = 1;
  List <Widget> screen = [
    signup_student(),
    status(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
      "Demo Admission App",
      style: TextStyle(
        color: Colors.red,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    ),
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header with Gradient Background
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("https://as1.ftcdn.net/jpg/01/48/92/30/1000_F_148923093_ioYDWrQR390tw2owYgy6tRex3RbwqHlO.jpg"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Hello USER!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SmartDrawer(
                    icon: Icons.info,
                    text: "Status",
                    onTap: (){
                      setState(() {
                        selected_screen = 1;
                        Navigator.pop(context);
                      });
                    },
                  ),
                  SmartDrawer(
                    icon: Icons.person,
                    text: "Signup Student",
                    onTap: (){
                      setState(() {
                        selected_screen = 0;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: screen[selected_screen],
      floatingActionButton: Icon(Icons.abc_sharp),
    );
  }
}

