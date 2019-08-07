import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';
// import 'customization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class HomeScreen extends StatefulWidget{
  HomeScreen({this.company, this.mainTile});
  final String company;
  final Widget mainTile;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

void initialMessage(company) async {
  // currentMessage = StreamBuilder(
  //   stream: db(company).orderBy("timestamp", descending: true).limit(1).snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         print(currentMessage);

  //       //todo: add circle progress indicator

  //       return ListView(children: snapshot.data.documents.map((document) {
  //         String title = document["title"];
  //         String message = document["message"];
  //         String details = document["details"];
  //          String url = document["url"];
  //          String fileURL = document["fileURL"];
  //         return MainTile(company: company,
  //           title: title,
  //           message: message,
  //           details: details,
  //           url: url,
  //           fileURL: fileURL,
  //         );
  //       }).toList()
  //       );
  //       });
      }

@override
void initState() {
super.initState();
  print(currentMessage);

initialMessage(widget.company);

  print(currentMessage);

}

  @override
  Widget build(BuildContext context) {
    print("THIS IS IN THE HOME SCREEEN BUILD FUNCTION");
      print(currentMessage);

    return Container(
        child: Column(children: <Widget>[
      // Expanded(child: widget.mainTile,),
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
  ButtonBar(
    alignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[emailButton(), smsButton(), phoneButton()],);;
  }
}