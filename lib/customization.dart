import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
















Widget getCompany(uid) {
  return FutureBuilder(
    future: db("users").document(uid).get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasData) {
        String company = snapshot.data["company".toString()];
        return company != "" ? Text(company) : Text("Union Connect");
      } else return Text("Union Connect");
    },
  );
}

Widget getCustomText(company, String _string) {
  return FutureBuilder(
    future: db(company).document("text").get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasData) {
        String title = snapshot.data[_string.toString()];
        return title != "" ? Text(title) : IgnorePointer();
      } else {
        return IgnorePointer();
      }
    },
    );
}

Widget getCustomLogo(company) {
  return FutureBuilder(
    future: db(company).document("logo").get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasData) {
        String _image = snapshot.data["logo".toString()];
        return Image.network(_image);
      } else {
        return IgnorePointer();
      }
    },
  );
}



