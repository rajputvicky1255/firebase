import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class add_Product extends StatefulWidget {
  const add_Product({super.key});

  @override
  State<add_Product> createState() => _add_ProductState();
}

class _add_ProductState extends State<add_Product> {

  TextEditingController ProductName =TextEditingController();
  TextEditingController Quntity = TextEditingController();
  TextEditingController SalePrice = TextEditingController();
  TextEditingController RealPrice = TextEditingController();

  final ImagePicker picker = ImagePicker();
  File? imagefile = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text("Add Product"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          child:Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [


                (imagefile!=null)?Image.file(imagefile!,height: 300,):Image.asset("img/OIP.jpeg",height: 300,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: ()async{
                      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

                     setState(() {
                       imagefile = File(photo!.path);
                     });

                    }, child: Text("Camera")),
                    ElevatedButton(onPressed: ()async{
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imagefile = File(image!.path);
                      });
                    }, child: Text("Gallary")),
                  ],
                ),

                SizedBox(height: 10,),
                TextField(
                  controller: ProductName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "ProductName",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),

                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: Quntity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                  labelText: "Quality",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                  ),
                ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: SalePrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Sale Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),

                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: RealPrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Real Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),

                    ),
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: ()async{
                  var pn = ProductName.text.toString();
                  var qt = Quntity.text.toString();
                  var sp = SalePrice.text.toString();
                  var rp = RealPrice.text.toString();

                  print(pn);
                  print(qt);
                  print(sp);
                  print(rp);

                  var uuid = Uuid();
                  var filename = uuid.v4() + ".jpg"; //110ec58a-a0f2-4ac4-8393-c866d813b8d1.jpg

                    await FirebaseStorage.instance.ref(filename).putFile(imagefile!).whenComplete((){}).then((filedata)async{
                      await filedata.ref.getDownloadURL().then((fileurl)async{
                      await FirebaseFirestore.instance.collection("product").add({
                        "Pname": pn,
                        "qty": qt,
                        "saleprice": sp,
                        "realprice": rp,
                        "imagename":filename,
                        "imageurl":fileurl
                      }).then((val){
                        print("Product Data Add successfuly");
                        ProductName.clear();
                        Quntity.clear();
                        SalePrice.clear();
                        RealPrice.clear();
                      });
                    });
                  });



                },
                    child: Text("Add Product"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
