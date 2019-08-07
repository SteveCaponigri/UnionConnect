import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'login.dart';

Color mainColor = Color.fromARGB(255, 50, 50, 150);
Color accent = Color.fromARGB(255, 206, 207, 239);
Widget currentMessage = Text("Info comes here soon");
var db = Firestore.instance.collection;



class HomeScreen1 extends StatefulWidget{
  HomeScreen1({this.company});
  final String company;

  @override
  _HomeScreenState1 createState() => _HomeScreenState1();
}

class _HomeScreenState1 extends State<HomeScreen1>{

void initialMessage(company) async {
  currentMessage = StreamBuilder(
    stream: db(company).orderBy("timestamp", descending: true).limit(1).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //todo: add circle progress indicator

        return ListView(children: snapshot.data.documents.map((document) {
          String title = document["title"];
          String message = document["message"];
          String details = document["details"];
           String url = document["url"];
           String fileURL = document["fileURL"];
          return Column(children:[
            Text(title),
            Text(message),
            Text(details),
          ]);
        }).toList()
        );
        });
      }

@override
void initState() {
super.initState();
print("INIT STATE BEFORE INITISAL MESSAGE");
  print(currentMessage);

initialMessage(widget.company);
print("INIT STATE AFTER INITISAL MESSAGE");

  print(currentMessage);

}

Widget myDrawer (String company, BuildContext context, String user, String logoURL) {
  return Drawer(
    child: Container(
      color: accent,
      padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
      child: Column(children: <Widget>[
        // contactInfo(user),
        Text("Recent Messages", style: TextStyle(fontWeight: FontWeight.bold),),
        Expanded(child: messagesList(company, user),),
        Divider(color: mainColor,),
        ListTile(title: Text("Close"),
          trailing: Icon(Icons.cancel, color: mainColor),
          onTap: () => Navigator.pop(context),
      ),
      ListTile(title: Text("Log Out"),
        trailing: Icon(Icons.exit_to_app, color: mainColor,),
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          exit(0);
          runApp(MaterialApp(home: RootPage(),));
        },
      ),
    ],),)
    
  );
}

Widget messagesList (company, user){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(widget.company).orderBy("timestamp", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
        return ListView(
          padding: EdgeInsets.all(24.0),
          children: snapshot.data.documents.map((document) {
            String _title = document["title"];
            String _message = document["message"];
            String _details = document["details"];
            String _url = document["url"];
            String _fileURL = document["fileURL"];
            return ListTile(
              title: Text(_title),
              trailing: Icon(Icons.chevron_right, color: mainColor),
              onTap: () {
                setState(() {
                    currentMessage = 
                    Text(_title); 
                });
                print("Set State Set $_title, $_message, $_details");
                Navigator.pop(context);
              });
            }).toList(),
        );
      },
    );

}








  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Expanded(child: currentMessage,),
      (contactEmail == null && contactPhone == null && contactText == null) ? IgnorePointer():
      ContactButtonBar(),        
        ],),
      );
  }
}

class ContactButtonBar extends StatelessWidget {

emailContact() {
  print("THE EMAIL IS $contactEmail");
  launch("mailto:$contactEmail");
}
phoneContact() {
  launch("tel:$contactPhone");
}
smsContact() {
  launch("sms:$contactText");
}

Widget emailButton(){
  return FloatingActionButton(
    backgroundColor: mainColor,
    onPressed: emailContact(),
    child: Icon(Icons.email),
  );
}

Widget phoneButton(){
  return FloatingActionButton(
    backgroundColor: mainColor,
    onPressed: phoneContact(),
    child: Icon(Icons.phone),
  );
}

Widget smsButton(){
  return FloatingActionButton(
    backgroundColor: mainColor,
    onPressed: smsContact(),
    child: Icon(Icons.sms),
  );
}

  @override
  Widget build(BuildContext context) {
    return  
  ((contactEmail == null || contactEmail == "" ) && (contactPhone == null || contactPhone == 0) && (contactText == null || contactText == 0)) ? IgnorePointer() :
  ((contactEmail == null || contactEmail == "" ) && (contactPhone == null || contactPhone == 0)) ? smsButton() :
  ((contactEmail == null || contactEmail == "" ) && (contactText == null || contactText == 0))  ? emailButton() :
  ((contactText == null || contactText == 0) && (contactPhone == null || contactPhone == 0)) ? phoneButton() :
  (contactEmail == null || contactEmail == "" ) ? ButtonBar(children: <Widget>[phoneButton(), smsButton()]) :
  (contactText == null || contactText == 0) ? ButtonBar(children: <Widget>[phoneButton(), emailButton()],) :
  (contactPhone == null || contactPhone == 0) ? ButtonBar(children: <Widget>[emailButton(), smsButton()],):
  ButtonBar(children: <Widget>[emailButton(), smsButton(), phoneButton()],);;
  }
}