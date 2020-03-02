import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:sentry/sentry.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';



  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SentryClient sentry = new SentryClient(dsn: 'https://44236c005c114ba48e86386d4ced21d5@sentry.io/3103940');
  bool _saving = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo', //예쁜 속성들이 많음
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  email=value;
                },
                decoration: kMessageTextFieldDecoration.copyWith(
                  hintText: "Enter Your Email"
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true, //password
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                 password=value;
                },
                decoration: kMessageTextFieldDecoration.copyWith(
                  hintText: "Enter Your Password"
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        _saving=true;
                      });
                      final user = await _auth
                          .signInWithEmailAndPassword(
                              email: email.trim(), password: password.trim())
                          .catchError((e) async {
                            setState(() {
                              _saving=false;
                            });
                        Toast.show("로그인 실패 ", context,
                            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                            await sentry.captureException(exception: 'login error',stackTrace: e.toString());
                      });

                      if (user != null) {
                        setState(() {
                          _saving=false;
                        });
                        Navigator.pushNamed(context, ChatScreen.id);
                      } else {
                        print('User가 null이에요.');
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      inAsyncCall: _saving),
    );
  }
}
