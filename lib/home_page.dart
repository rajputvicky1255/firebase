import 'package:firebaseex/add_Employae.dart';
import 'package:firebaseex/add_Product.dart';
import 'package:firebaseex/view_Employae.dart';
import 'package:firebaseex/view_Product.dart';
import 'package:flutter/material.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {

  var FirebaseAuth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(accountName: Text("VickyRajput"), accountEmail: Text("vicky19r@gmail.com"),
            currentAccountPicture: ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>add_Employae()));
            }, child: Text("Add Employae")),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>view_Employae()));
            }, child: Text("View Employae")),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>add_Product()));
            }, child: Text("Add Product")),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>view_Product()));
            }, child: Text("View Product")),
            ],
            ),
          ],
        ),
      ),
    );
  }
}
