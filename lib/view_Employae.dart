import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseex/Edit_Employae.dart';
import 'package:firebaseex/add_Employae.dart';
import 'package:flutter/material.dart';

class view_Employae extends StatefulWidget {
  view_Employae({super.key});

  @override
  State<view_Employae> createState() => _view_EmployaeState();
}

class _view_EmployaeState extends State<view_Employae> {
  Future<List?>? alldata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: Center(
        child: Text("View Employae"),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Employae").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size <= 0) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return ListView(
                  children: snapshot.data!.docs.map((document) {
                return GestureDetector(
                  onLongPress: () {
                    AlertDialog dialog = AlertDialog(
                      title: Text("Delete"),
                      content: Text("Are you sure you want to delete this?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Delete"),
                          onPressed: () async {
                            var id = document.id.toString();
                            print("id = ${id}");
                            await FirebaseStorage.instance.ref(document["imagename"]).delete().then((val)async{
                            await FirebaseFirestore.instance.collection("Employae").doc(id).delete().then((val) {
                              print("data delete!");
                              Navigator.of(context).pop();
                            });
                            });
                            // Navigator.of(context).pop();
                          },),
                      ],
                    );
                    showDialog(context: context, builder: (context) {
                      return dialog;
                    });
                  },
                  onTap: () {
                    var id = document.id.toString();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Edit_Employae(updateid: id,)));
                    },
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade700,
                    ),
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text("Name:" + document["Ename"].toString()),
                            SizedBox(height: 10,),
                            Text("Name:" + document["email"].toString()),
                            SizedBox(height: 10,),
                            Text("Name:" + document["Contect"].toString()),
                            SizedBox(height: 10,),
                            Text("Name:" + document["Gender"].toString()),
                            SizedBox(height: 10,),
                            Text("Name:" + document["Salary"].toString()),
                            SizedBox(height: 10,),
                            Text("Name:" + document["Date"].toString()),
                            SizedBox(height: 20),
                              ],
                            ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(25),
                              child: Container(
                                  height: 170,
                                  width: 135,
                                  color: Colors.white70,
                                  child:Image.network(document["imageurl"])
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ),
                );
                  }).toList()
              );}
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}