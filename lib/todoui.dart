// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/dbhelper.dart';
import 'package:todo_app/main.dart';

class todoui extends StatefulWidget {
  const todoui({Key key}) : super(key: key);

  @override
  _todouiState createState() => _todouiState();
}

class _todouiState extends State<todoui> {
  final dbhelper = Databasehelper.instance;

  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String todoedited = "";
  var myitems = List();
  List<Widget> children = new List<Widget>();



  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited = "";
    setState(() {
      validated = true;
      errtext = "";
    });
  }



  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          padding: EdgeInsets.all(5),
          child: ListTile(
            trailing: Icon(Icons.delete_forever_rounded,color: Colors.grey,),
            title: Text(
              row['todo'],
              style: TextStyle(fontSize: 18),
            ),
            onLongPress: () {
              dbhelper.deletedata(row['id']);
              setState(() {

              });
            },
          ),
        ),
      )
      );
    });
    return Future.value(true);
  }




  void showalertDialog() {
    texteditingcontroller.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: texteditingcontroller,
                    autofocus: true,
                    onChanged: (_val) {
                      todoedited = _val;
                    },
                    cursorColor: Colors.teal,
                    style: TextStyle(fontSize: 20),
                    decoration:
                        InputDecoration(errorText: validated ? null : errtext),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            if (texteditingcontroller.text.isEmpty) {
                              setState(() {
                                errtext = "Can't Be Empty!";
                                validated = false;
                              });
                            } else if (texteditingcontroller.text.length >
                                512) {
                              setState(() {
                                errtext = "Oops, too many Characters!";
                              });
                            } else {
                              addtodo();
                            }
                          },
                          color: Colors.teal,
                          child: Text(
                            "ADD",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }




  // Widget mycard(String task) {
  //   return Card(
  //     elevation: 5,
  //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     child: Container(
  //       padding: EdgeInsets.all(5),
  //       child: ListTile(
  //         title: Text(
  //           "$task",
  //           style: TextStyle(fontSize: 18),
  //         ),
  //         onLongPress: () {
  //           print("Deleted ");
  //         },
  //       ),
  //     ),
  //   );
  // }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text("No Data."),
          );
        } else {
          if (myitems.length == 0) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertDialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal,
              ),
              appBar: AppBar(
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              body: Center(child: Text("No Task Available!",
              style: TextStyle(fontSize: 20),),),
            );
          }else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertDialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal,
              ),
              appBar: AppBar(
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
}

// Scaffold(
// floatingActionButton: FloatingActionButton(
// onPressed: showalertDialog,
// child: Icon(
// Icons.add,
// color: Colors.white,
// ),
// backgroundColor: Colors.teal,
// ),
// appBar: AppBar(
// title: Text(
// "My Tasks",
// style: TextStyle(
// color: Colors.white,
// fontSize: 23,
// fontFamily: "Raleway",
// fontWeight: FontWeight.bold),
// ),
// backgroundColor: Colors.black,
// centerTitle: true,
// ),
// backgroundColor: Colors.black,
// body: SingleChildScrollView(
// child: Column(
// children: [
// mycard("Record A Video"),
// mycard("Go To Sleep"),
// mycard("Record SQFLITE Video \nInsert \nQuery \nDelete \nUpdate"),
// mycard("Buy Groceries \nApple \nMilk \nRice \nMushroom \nLentils"),
// mycard("Record SQFLITE Video \nInsert \nQuery \nDelete \nUpdate"),
// mycard("Buy Groceries \nApple \nMilk \nRice \nMushroom \nLentils"),
// mycard("Record SQFLITE Video \nInsert \nQuery \nDelete \nUpdate"),
// mycard("Buy Groceries \nApple \nMilk \nRice \nMushroom \nLentils"),
// ],
// ),
// ),
// );
