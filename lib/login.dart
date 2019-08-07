import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color i8Blue = Color.fromARGB(255, 50, 50, 150);


final loginKey = new GlobalKey<FormState>();
String idNumber;
enum AuthStatus {
  notSignedIn, signedIn
}

Future<String> currentUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      return user.uid;
    }   

class RootPage extends StatefulWidget{
  RootPageState createState() => new RootPageState();
}

class RootPageState extends State<RootPage>{
String company;
String user;

  @override
     void initState() { 
       super.initState();
       companyText();
     }

void companyText() async {
       String userId = await currentUser();
       var textCompany = await Firestore.instance.collection("users").document(userId).get();
        String _company = textCompany.data["company".toString()]; 
        String _user = textCompany.data["name".toString()];
       setState(() {
         print("THIS IS THE USER THAT SIGNED IN $_user and $_company");
        company = _company; 
        user = _user;
        authStatus = _user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
       });
     }

  AuthStatus authStatus = AuthStatus.notSignedIn;

  void _signedIn() {
    setState(() {
     authStatus = AuthStatus.signedIn; 
    });
  }

  void _signedOut() {
    setState(() {
     authStatus = AuthStatus.notSignedIn; 
    });
  }

  @override
  Widget build(BuildContext context) {

    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(onSignedIn: _signedIn);
        case AuthStatus.signedIn:
        return MyHomePage(company: company, user: user, onSignedOut: _signedOut,);
    }

    // return user == null ? LoginPage(onSignedIn: _signedIn,) : 
    // MyHomePage(company: company, user: user,);
  }
}



class LoginPage extends StatefulWidget{
  LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>{

bool validateAndSave(){
  final form = loginKey.currentState;
  if (form.validate()) {
    form.save();
return true;
  } else {
return false;  }
}

void validateAndSubmit() async {
 if (validateAndSave()) {
   try {
   FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: idNumber + "@email.com", password: "password");
    print("Signed in as ${user.uid}");
    widget.onSignedIn();
    }
    catch (e) {
      print ("Error: $e");
    }
 }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: i8Blue,
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: loginKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: "logo",
                  child: Image.asset("UC word Logo.png")),
                flex: 1,
                ),
            
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Union ID Number",
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) => value.isEmpty ? "Enter your ID Number to Log In" : null,
              onSaved: (value) => idNumber = value,
            ),
//ADD A SPOT HERE TO SELECT THE UNION
Padding(padding: EdgeInsets.all(4.0)),
        RaisedButton(
          child: Text("Login",
          style: new TextStyle(
            fontSize: 22.0
          ),
          ),
          color: Colors.white,
          onPressed: validateAndSubmit,
        ),
          ],),
        )
      ),
      );
  }
}
