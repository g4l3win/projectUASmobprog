import 'package:flutter/material.dart';
import '../database/user_command.dart';
import '../screens/SignIn.dart';
import '../models/user.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernamefield = TextEditingController();
  TextEditingController passwordfield = TextEditingController();
  TextEditingController passwordvalidationfield = TextEditingController();
  final formState = GlobalKey<FormState>();
  final passwordvalidationFocus = FocusNode();
  final passwordFocus = FocusNode();
  final usernameFocus = FocusNode();
  UserCommand dbUser = UserCommand();
  var _isObsecured;
  var _isOser;
  void initState() {
    super.initState();
    _isObsecured = true;
    _isOser = true;
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
                  "Sign Up",
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
                          if (value == null || value!.isEmpty) {
                            usernameFocus.requestFocus();
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
                        focusNode: passwordFocus,
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
                          if (value == null || value!.isEmpty) {
                            passwordFocus.requestFocus();
                            return "Password wajib di isi";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25, bottom: 25),
                      child: TextFormField(
                        enabled: true,
                        controller: passwordvalidationfield,
                        obscureText: _isObsecured,
                        focusNode: passwordvalidationFocus,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: "Password Confirmation",
                          labelText: "Password Confirmation",
                        ),
                        validator: (value) {
                          if (value == null || value!.isEmpty) {
                            passwordFocus.requestFocus();
                            return "Password wajib di isi";
                          }
                          if (value != passwordfield.text) {
                            passwordvalidationFocus.requestFocus();
                            return "Password Berbeda";
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
                          User user = User(
                            username: usernamefield.text,
                            password: passwordfield.text,
                          );
                          await dbUser.insertUser(user);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signin()));
                        }
                      },
                      child: Text("Create Account",
                          style: TextStyle(
                            color: Color.fromARGB(255, 50, 198, 227),
                          )),
                    ),
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
                            return Signin();
                          }));
                        },
                        child: Text("Sign In",
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
