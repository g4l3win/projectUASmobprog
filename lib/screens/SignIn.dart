import 'package:flutter/material.dart';
import 'package:quizdb/screens/welcome_screen.dart';
import '../database/user_command.dart';
import '../screens/SignUp.dart';
import '../models/user.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController usernamefield = TextEditingController();
  TextEditingController passwordfield = TextEditingController();
  final formState = GlobalKey<FormState>();
  late UserCommand dbUser = UserCommand();
  final passwordFocus = FocusNode();
  var _isObsecured;
  void initState() {
    super.initState();
    _isObsecured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 205, bottom: 25),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(255, 50, 198, 227),
                      fontWeight: FontWeight.w600),
                ),
              ),
              Form(
                key: formState,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 25, bottom: 25),
                      child: TextFormField(
                        enabled: true,
                        controller: usernamefield,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: "Username",
                          labelText: "Username",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25, bottom: 25),
                      child: TextFormField(
                        enabled: true,
                        controller: passwordfield,
                        obscureText: _isObsecured,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: "Password",
                          labelText: "Password",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          User? user = await dbUser.signIn(
                              usernamefield.text, passwordfield.text);
                          if (user != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomeScreen()));
                          } else {
                            Widget okButton = TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'));
                            AlertDialog alert = AlertDialog(
                              title: Text("Error"),
                              content: Text("Username atau Password Salah"),
                              actions: [okButton],
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                });
                          }
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color.fromARGB(255, 50, 198, 227),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return Signup();
                          }));
                        },
                        child: Text("Sign Up",
                            style: TextStyle(
                              color: Color.fromARGB(255, 50, 198, 227),
                            )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
