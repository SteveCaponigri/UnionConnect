import 'package:flutter/material.dart';
import 'constants.dart';
import 'drawer.dart';


class MessagePage extends StatelessWidget {
  MessagePage({this.title, this.message, this.details, this.url, this.fileURL, this.logoURL, this.company, this.user});
  final String title;
  final String message;
  final String details;
  final String url;
  final String fileURL;
  final String logoURL;
  final String company;
  final String user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
    title: FittedBox(child: Text(title),),
    backgroundColor: mainColor,
    actions: <Widget>[
      (logoURL == null || logoURL == "") ? Image.asset("UC Logo.png"): 
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Image.network(logoURL),),
    ],
  ),
  drawer: myDrawer(company, context, user, logoURL),
  body: Expanded(child: MainTile(
    company: company,
    details: details,
    message: message,
    fileURL: fileURL,
    title: title,
    url: url,
  ),),
    );
  }
}