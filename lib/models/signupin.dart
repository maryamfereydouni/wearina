import 'package:flutter/material.dart';
import 'package:wearina/models/signin.dart';
import 'package:wearina/models/signup.dart';

class SignUpIn extends StatefulWidget {
  const SignUpIn({super.key});

  @override
  State<SignUpIn> createState() => _SignUpInState();
}

class _SignUpInState extends State<SignUpIn>
    with SingleTickerProviderStateMixin<SignUpIn> {
  late TabController cont;
  @override
  void initState() {
    super.initState();
    cont = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(
              top: he * .05,
              right: wi * .2,
              left: wi * .2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(15),
            ),
            height: he * .09,
            child: TabBar(
                controller: cont,
                indicatorColor: Colors.pink[400],
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.blueGrey[800],
                labelStyle: TextStyle(fontSize: wi * .034, fontFamily: 'sans'),
                unselectedLabelColor: Colors.blueGrey[400],
                unselectedLabelStyle: TextStyle(fontSize: wi * .032),
                tabs: [
                  Tab(
                    text: "ورود",
                  ),
                  Tab(
                    text: "ثبت نام",
                  ),
                ]),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: he * .04),
              child: TabBarView(
                controller: cont,
                children: [
                  SignIn(),
                  SignUp(),
                ],
              ),
            ),
          ),
        ]),
      )),
    );
  }
}
