import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class add_Employae extends StatefulWidget {
  const add_Employae({super.key});

  @override
  State<add_Employae> createState() => _add_EmployaeState();
}

class _add_EmployaeState extends State<add_Employae> {

  var Select="acount";
  var Gender;
  var DOB = "";

  TextEditingController EmployaeName =TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Contect = TextEditingController();
  TextEditingController Salary = TextEditingController();
  TextEditingController date = TextEditingController();


  final ImagePicker picker = ImagePicker();
  File? imagefile = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: Center(
        child: Text("Employae"),
        ),
      ),

      body: SingleChildScrollView(
          child: Container(
            margin:EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  (imagefile!=null)?Image.file(imagefile!,height: 300,):Image.asset("img/virtus.gt.jpg",height: 300,),

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
                  TextFormField(
                    controller: EmployaeName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText:"Employae",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: Email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: Contect,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: "Contect",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("male"),
                      Radio
                        (value: "male",
                        groupValue:Gender,
                        onChanged: (val){
                          setState(() {
                            Gender = val;
                          });
                        },
                      ),
                      Text("female"),
                      Radio
                        (value: "female",
                        groupValue:Gender,
                        onChanged: (val){
                          setState(() {
                            Gender = val;
                          });
                        },
                      ),
                    ],
                  ),
                  DropdownButton(
                    value: Select,
                    onChanged: (val)
                    {
                      setState(() {
                        Select = val!;
                        print("Select =${Select}");
                      });
                    },
                    items:[
                      DropdownMenuItem(child: Text("account"),value: "acount",),
                      DropdownMenuItem(child: Text("manager"),value: "manager",),
                    ],
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: Salary,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Salary",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  TextField(
                    controller: date, //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2050));

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          date.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: ()async{
                    var en = EmployaeName.text.toString();
                    var em = Email.text.toString();
                    var ct = Contect.text.toString();
                    var sl = Salary.text.toString();
                    var ge = Gender.toString();
                    var dob = date.text.toString();

                    print(en);
                    print(em);
                    print(ct);
                    print(sl);
                    print(ge);
                    print(dob);


                    var uuid = Uuid();
                    var filename = uuid.v4() + ".jpg"; //110ec58a-a0f2-4ac4-8393-c866d813b8d1.jpg

                    await FirebaseStorage.instance.ref(filename).putFile(imagefile!).whenComplete((){}).then((filedata)async{
                    await filedata.ref.getDownloadURL().then((fileurl)async{
                    await FirebaseFirestore.instance.collection("Employae").add({
                      "Ename": en,
                      "email": em,
                      "Contect": ct,
                      "Salary": sl,
                      "Gender":ge,
                      "Date":dob,
                      "imagename":filename,
                      "imageurl":fileurl
                       }).then((val){
                         print("Employae Data Add successfuly");
                         EmployaeName.clear();
                         Email.clear();
                         Contect.clear();
                         Salary.clear();
                       //  Gender.clear();
                         date.clear();
                       });
                    },);
                    },);

                    },
                      child: Text("Add Employae"))
                ],
              ),
            ),
          ),
        ),

    );
  }
}
