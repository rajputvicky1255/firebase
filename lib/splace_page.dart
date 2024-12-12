import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';

class splace_page extends StatefulWidget {
  const splace_page({super.key});

  @override
  State<splace_page> createState() => _splace_pageState();
}

class _splace_pageState extends State<splace_page> {

  initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => home_page()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child:FlutterLogo(size:MediaQuery.of(context).size.height),
      ),
    );
  }
}
