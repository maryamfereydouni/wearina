import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wearina/pages/main_screen/main_screen.dart';
import 'package:wearina/models/sharedPref.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  GlobalKey<ScaffoldState> scaff = GlobalKey();
  late File imageFile;

  Future getImage() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  uploadData() async {
    // image sending process

    await http.post(Uri.http("http://127.0.0.1:3000/signup"), body: {
      // "image":"",
      // "imageName":"",
      "name": nameCont.text.trim(),
      "phone": phoneCont.text.trim(),
      "email": emailCont.text.trim(),
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
                    ? "اطلاعات با موفقیت ثبت شد"
                    : "کاربر با این مشخصات وجود دارد",
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
    nameCont.text.trim().isEmpty ||
            emailCont.text.trim().isEmpty ||
            phoneCont.text.trim().isEmpty ||
            passCont.text.trim().isEmpty
        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.pink[400],
            elevation: 10,
            duration: Duration(seconds: 4),
            content: Container(
              height: scaff.currentContext!.size!.height * .1,
              child: Center(
                child: Text(
                  textDirection: TextDirection.rtl,
                  "از خالی ذاشتن فیلد ها خودداری نمایید...",
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

    return Scaffold(
      key: scaff,
      body: Container(
        width: wi,
        height: he,
        child: ListView(
          children: [
            SizedBox(
              height: he * .07,
            ),
            inputModel(
              wi,
              he,
              nameCont,
              25,
              TextInputType.text,
              TextInputAction.done,
              "نام کاربری",
              Icons.person_outline_rounded,
              false,
            ),
            SizedBox(
              height: he * .03,
            ),
            inputModel(
              wi,
              he,
              emailCont,
              25,
              TextInputType.emailAddress,
              TextInputAction.done,
              "ایمیل",
              Icons.email_outlined,
              false,
            ),
            SizedBox(
              height: he * .03,
            ),
            inputModel(
              wi,
              he,
              phoneCont,
              11,
              TextInputType.phone,
              TextInputAction.done,
              "موبایل",
              Icons.phone_iphone,
              false,
            ),
            SizedBox(
              height: he * .03,
            ),
            inputModel(
              wi,
              he,
              passCont,
              50,
              TextInputType.text,
              TextInputAction.done,
              "رمز عبور",
              Icons.lock_open,
              true,
            ),
            SizedBox(
              height: he * .05,
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
                      "ثبت اطلاعات",
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
