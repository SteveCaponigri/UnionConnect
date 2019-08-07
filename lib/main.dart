import 'package:flutter/material.dart';
import 'package:unionconnect/home.dart';
import 'package:unionconnect/test.dart' as prefix0;
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'constants.dart';
import 'drawer.dart';

String logoURL;
String contactEmail;
int contactPhone;
int contactText;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Union Connect',
      home: RootPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.company, this.user}) : super(key: key);
  final String company;
  final String user;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
final FirebaseMessaging _fcm = FirebaseMessaging();



void customization(company) async {
       var customizations = await db("customizations").document(company).get();
       if (customizations.data["mainR"] != null) {
        int mainR = customizations.data["mainR"]; 
        int mainG = customizations.data["mainG"]; 
        int mainB = customizations.data["mainB"]; 
        int accentR = customizations.data["accentR"]; 
        int accentG = customizations.data["accentG"]; 
        int accentB = customizations.data["accentB"]; 
       setState(() {
        mainColor = Color.fromARGB(255, mainR, mainG, mainB);
        accent = Color.fromARGB(255, accentR, accentG, accentB);
       });
       } 
       logoURL = customizations.data["logo"];
       contactEmail = customizations.data["email"];
       contactPhone = customizations.data["phone"];
       contactText = customizations.data["textMessage"];
     }

void initialMessage(company) async {
        //  var initial = await db(company).document("1564970626634").get();
        //  setState(() {
        //   currentMessage = MainTile(
        //     company: company,
        //     details: initial.data["details"],
        //     fileURL: initial.data["fileURL"],
        //     message: initial.data["message"],
        //     title: initial.data["title"],
        //     url: initial.data["url"],
        //   );
        //  });


    setState(() {
     currentMessage = StreamBuilder(
    stream: db(company).orderBy("timestamp", descending: true).limit(1).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print(currentMessage);

        //todo: add circle progress indicator

        return ListView(children: snapshot.data.documents.map((document) {
          String title = document["title"];
          String message = document["message"];
          String details = document["details"];
           String url = document["url"];
           String fileURL = document["fileURL"];
          return MainTile(company: company,
            title: title,
            message: message,
            details: details,
            url: url,
            fileURL: fileURL,
          );
        }).toList()
        );
        }); 
    });
}

@override
void initState() { 
  super.initState();

  //Customizations
  customization(widget.company);

  //Initial Message
  initialMessage(widget.company);

  //Notifications
  _fcm.subscribeToTopic(widget.company.toString().replaceAll(" ", ""));
  _fcm.configure(
    onLaunch: (Map<String, dynamic> message) {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) {
      print("onResume: $message");
    },
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message["notification"]["title"]),
            subtitle: Text(message["notification"]["body"]),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        )
      );
    }
  );
  _fcm.requestNotificationPermissions(
    IosNotificationSettings(
      sound: true,
      alert: true,
      badge: true,
    )
  );
  _fcm.onIosSettingsRegistered.listen((IosNotificationSettings setting) {
    print("IOS Setting Registered");
  });
  _fcm.getToken().then((token) {
    update(token);
  });
}


update(String token) {
}



  @override
  Widget build(BuildContext context) {

  

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company),
        backgroundColor: mainColor,
        actions: <Widget>[
            logoURL == null ? Image.asset("UC Logo.png"): 
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Image.network(logoURL),),          
        ],
      ),
      drawer: myDrawer(widget.company, context, widget.user, logoURL),
      body: HomeScreen(
        company: widget.company,
        ),
      
      );
    
  }
}


