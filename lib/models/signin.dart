import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wearina/models/sharedPref.dart';
import 'package:wearina/pages/main_screen/main_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  GlobalKey<ScaffoldState> scaff = GlobalKey();

  uploadData() async {
    // image sending process

    await http.post(Uri.http("http://127.0.0.1:3000/signin"), body: {
      // "image":"",
      // "imageName":"",
      "name": nameCont.text.trim(),
      "pass": passCont.text.trim(),
    }).then((res) async {
      var body = jsonDecode(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.pink[400],
          elevation: 10,
          duration: Duration(seconds: 4),
          content: Container(
            height: scaff.currentContext!.size!.height * .1,
            child: Center(
              child: Text(
                textDirection: TextDirection.rtl,
                body['success'] == true
                    ? "خوش آمدید"
                    : "کاربر با این مشخصات وجود ندارد",
                style: TextStyle(
                  fontFamily: 'sans',
                  fontSize: scaff.currentContext!.size!.width * .033,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
      if (body['success'] == true) {
        await sharedPref().setPrefs('user', body['uuid'].toString());
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (c) => Home()));
      }
    }).catchError((err) {
      print("face up error:(((");
    });
  }

  checker() {
    nameCont.text.trim().isEmpty || passCont.text.trim().isEmpty
        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.pink[400],
            elevation: 10,
            duration: Duration(seconds: 4),
            content: Container(
              height: scaff.currentContext!.size!.height * .1,
              child: Center(
                child: Text(
                  textDirection: TextDirection.rtl,
                  "از خالی گذاشتن فیلد ها خودداری نمایید...",
                  style: TextStyle(
                    fontFamily: 'sans',
                    fontSize: scaff.currentContext!.size!.width * .033,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ))
        : uploadData();
  }

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    TextEditingController nameCont = TextEditingController();
    TextEditingController passCont = TextEditingController();

    return Scaffold(
      key: scaff,
      body: Container(
        width: wi,
        height: he,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: wi,
              height: he * .55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  inputModel(
                    wi,
                    he,
                    nameCont,
                    25,
                    TextInputType.emailAddress,
                    TextInputAction.done,
                    "نام کاربری / ایمیل",
                    Icons.person_outline_rounded,
                    false,
                  ),
                  inputModel(
                    wi,
                    he,
                    passCont,
                    50,
                    TextInputType.text,
                    TextInputAction.done,
                    "کلمه عبور",
                    Icons.lock_open,
                    true,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      checker();
                    },
                    child: Container(
                        constraints: BoxConstraints(minHeight: he * .065),
                        margin: EdgeInsets.only(
                          right: wi * .25,
                          left: wi * .25,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF7c9998),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "ورود",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'sans',
                              fontSize: wi * .035,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputModel(
    var wi,
    var he,
    TextEditingController cont,
    int max,
    TextInputType keyType,
    TextInputAction action,
    String label,
    IconData icon,
    bool ispassword,
  ) {
    return Container(
      margin: EdgeInsets.only(
        right: wi * .15,
        left: wi * .15,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          obscureText: ispassword,
          controller: cont,
          maxLength: max,
          textInputAction: action,
          keyboardType: keyType,
          cursorColor: Color(0xFF7c9998),
          decoration: InputDecoration(
            labelText: label,
            counterStyle: TextStyle(color: Colors.pink[300]),
            labelStyle: TextStyle(
                color: Colors.pink[300],
                fontFamily: 'sans',
                fontSize: wi * .03),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: Color(0xFF7c9998),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: Color(0xFF7c9998),
                width: 1,
              ),
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.pink[200],
            ),
          ),
        ),
      ),
    );
  }
}
