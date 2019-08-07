import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

Widget myDrawer (String company, BuildContext context, String user, String logoURL) {
  return Drawer(
    child: Container(
      color: accent,
      padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
      child: Column(children: <Widget>[
        contactInfo(user),
        Text("Recent Messages", style: TextStyle(fontWeight: FontWeight.bold),),
        Expanded(child: MessagesList(company: company, user: user, logoURL: logoURL,),),
        Divider(color: mainColor,),
        ListTile(title: Text("Close"),
          trailing: Icon(Icons.cancel, color: mainColor),
          onTap: () => Navigator.pop(context),
      ),
      ListTile(title: Text("Log Out"),
        trailing: Icon(Icons.exit_to_app, color: mainColor,),
        onTap: () async {
          print("User Signing out is $user");
          signOut();
          print("User Signed out is $user");
          // exit(0);
          runApp(MaterialApp(home: RootPage(),));
        },
      ),
    ],),)
    
  );
}

Future<void> signOut() async {
  
  await FirebaseAuth.instance.signOut();
}

class MessagesList extends StatefulWidget{
  MessagesList({this.company, this.user, this.logoURL});
  final String company;
  final String user;
  final String logoURL;
  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList>{

  @override
  Widget build(BuildContext context) {
    
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
                    MainTile(
                      company: widget.company,
                      details: _details,
                      title: _title,
                      message: _message,
                      url: _url,
                      fileURL: _fileURL,
                    );
                });
                Navigator.pop(context);


              });
            }).toList(),
        );
      },
    );
  }
}