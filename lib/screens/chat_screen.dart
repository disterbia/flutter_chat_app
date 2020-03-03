import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry/sentry.dart';

FirebaseUser loginCurrentUser; //클래스 외 전역변수는 메인 실행되기전 static처럼 뜸
final SentryClient sentry = new SentryClient(
    dsn: 'https://44236c005c114ba48e86386d4ced21d5@sentry.io/3103940');

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore=Firestore.instance;
  String messegeText;
  final messageTextController=TextEditingController();

  @override
  void initState() {
    super.initState();
    //시작시 실행되는것

    getCurrentUser();
  }

  void getCurrentUser()  async {
    try {
      final user = await _auth.currentUser();

      if (user != null) {
        loginCurrentUser = user;
      }
    } catch (e) {
      await sentry.captureException(
          exception: 'fobidden error', stackTrace: e.toString());
    }
  }

/*  @override
  void dispose() {
    // 끝날때 실행되는것
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        messegeText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      print('loginCurrentUser $loginCurrentUser');
                      _firestore.collection("messages").add({
                        'sender':loginCurrentUser.email,
                        'text':messegeText,
                        'date':FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
