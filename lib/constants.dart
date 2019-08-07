import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';


Color mainColor = Color.fromARGB(255, 50, 50, 150);
Color accent = Color.fromARGB(255, 206, 207, 239);
var db = Firestore.instance.collection;
Widget currentMessage = Text("Info comes here soon");


Widget contactInfo(String user){
  return Column(children: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      Text("Information For ",
      style: TextStyle(fontSize: 16.0),),
      Text(user,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
      
    ],),
  ],);
}





class MainTile extends StatelessWidget {
  MainTile ({this.title, this.message, this.details, this.url, this.fileURL, this.company});
  final String title;
  final String message;
  final String details;
  final String url;
  final String company;
  final String fileURL;


  @override
  Widget build(BuildContext context) {

    Widget websiteButton() {
      return RaisedButton(
            child: Row(children: <Widget>[
              Text("Website",
                style: TextStyle(color: Colors.white),
              ),
              Padding(padding: EdgeInsets.all(2.0),),
              Icon(Icons.launch, color: Colors.white,),
            ],),
              color: mainColor,
              onPressed: () => launch(url),
              );
    }
    
downloadFile() {}

Widget fileButton() {
return RaisedButton(color: mainColor,
              child: 
              Row(children: <Widget>[
                Text("Download",
                  style: TextStyle(color: accent),
                ),
                 Padding(padding: EdgeInsets.all(2.0),),
                Icon(Icons.file_download, color: accent,)
              ],),
              onPressed: downloadFile,
              );
}
    

    return Container(
      // color: Colors.white,
      padding: EdgeInsets.all(24.0),
      child: Column(children: <Widget>[
        Text(title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          )
          ),
        Divider(color: mainColor,),
        Text(message,
        style: TextStyle(fontWeight: FontWeight.bold),),
        Padding(padding: EdgeInsets.all(8.0),),
        Expanded(child: SingleChildScrollView(child: Text(details),),),
        
        (url =="" && fileURL == "") ? IgnorePointer() :
        (url == "") ? fileButton() : (fileURL == "") ? websiteButton() :
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          websiteButton(),
          fileButton(),
        ],),
        
      ],),
      );
    
  }
}