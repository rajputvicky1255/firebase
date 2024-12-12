import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseex/Edit_Product.dart';
import 'package:flutter/material.dart';

class view_Product extends StatefulWidget {
  const view_Product({super.key});

  @override
  State<view_Product> createState() => _view_ProductState();
}

class _view_ProductState extends State<view_Product> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: Center(
      ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("product").snapshots(),
        builder: (context, snapshort) {
          if (snapshort.hasData) {
            if (snapshort.data!.size <= 0) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return ListView(
                children: snapshort.data!.docs.map((document) {
                  return GestureDetector(
                    onLongPress: (){
                      AlertDialog dialog =  AlertDialog(
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
                            child:Text("Delete"),
                            onPressed: ()async{

                              var id = document.id.toString();
                              print("id = ${id}");

                              await FirebaseStorage.instance.ref(document["imagename"]).delete().then((val)async{
                                await FirebaseFirestore.instance.collection("product").doc(id).delete().then((val){
                                  print("data delete!");
                                  Navigator.of(context).pop();
                                });
                              });


                              // Navigator.of(context).pop();
                            },),
                        ],
                      );
                      showDialog(context: context, builder: (context){return dialog;});
                    },
                    onTap: (){
                      var id = document.id.toString();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>Edit_Product(
                          updateid: id,
                        ))
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [

                                  Text("Name:" + document["Pname"].toString()),
                                  Text("Quntity :" + document["qty"].toString()),
                                  Row(
                                    children: [
                                      Text("Real Price:" + document["realprice"].toString()),
                                      Text("Sell Price:" + document["saleprice"].toString()),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Container(
                                        height: 70,
                                        width: 70,
                                        color: Colors.white70,
                                        child:Image.network(document["imageurl"])
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
