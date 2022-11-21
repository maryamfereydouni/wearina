import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wearina/models/bigSearch.dart';
import 'package:wearina/models/item_detail.dart';
import 'package:wearina/pages/about/about.dart';
import 'package:wearina/pages/checkout/checkout.dart';
import 'package:wearina/pages/profile/profile.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int active = 0;
  GlobalKey<ScaffoldState> state = GlobalKey();
  List cats = [];
  List prods = [];

  String process = "درحال دریافت اطلاعات";

  getData() async {
    await http.get(Uri.http('http://localhost:3000', 'getProducts'), headers: {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
    }).then((res) {
      // var bod = utf8.decode(res.bodyBytes);
      var body = jsonDecode(res.body);
      if (body['categories'].toString().isEmpty &&
          body['products'].toString().isEmpty) {
        setState(() {
          process = "اطلاعات موجود نیست";
        });
      } else if (body['categories'].toString().isNotEmpty &&
          body['products'].toString().isNotEmpty) {
        setState(() {
          cats = body['categories'];
          prods = body['products'];
        });
      }
    });
  }

  getDetailProduct(int index) async {
    await http
        .post(Uri.http('http://localhost:3000', 'getCatProds'),
            headers: {
              "Accept": "application/json",
              "Access-Control_Allow_Origin": "*"
            },
            body: jsonEncode({"uuid": cats[index]['categoryID']}))
        .then((res) {
      // var bod = utf8.decode(res.bodyBytes);
      var body = jsonDecode(res.body);
      if (body['products'].toString().isEmpty) {
        setState(() {
          process = "محصولی موجود نیست";
        });
      } else if (body['products'].toString().isNotEmpty) {
        setState(() {
          prods = body['products'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      key: state,
      endDrawer: Container(
        width: wi * .2,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 15,
                offset: Offset(-1, 0),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NavItem(wi, he, Icons.person_outline, 1),
            NavItem(wi, he, Icons.shopping_bag_outlined, 2),
            NavItem(wi, he, Icons.priority_high_rounded, 3),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        width: wi,
        height: he,
        color: const Color(0xFF7c9998),
        child: ListView(
          children: [
            Container(
                color: const Color(0xFF7c9998),
                height: he * .15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: wi * .06),
                      child: Text(
                        "Wearina",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: wi * .08,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: wi * .06),
                        child: InkWell(
                          onTap: () {
                            if (state.currentState!.isEndDrawerOpen) {
                              Navigator.of(context).pop();
                            } else {
                              state.currentState!.openEndDrawer();
                            }
                          },
                          child: Icon(
                            Icons.sort,
                            color: Colors.white,
                            size: wi * .08,
                          ),
                        )),
                  ],
                )),
            Container(
              constraints: BoxConstraints(minHeight: he * .09),
              padding: EdgeInsets.only(
                left: wi * .03,
                right: wi * .03,
                top: wi * .02,
              ),
              margin: EdgeInsets.symmetric(horizontal: wi * .065),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white24,
              ),
              child: Hero(
                tag: 'search',
                child: Material(
                  type: MaterialType.transparency,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => bigSearch(),
                            transitionDuration: Duration(seconds: 1)));
                      },
                      maxLength: 30,
                      textDirection: TextDirection.rtl,
                      cursorColor: Colors.blueGrey[800],
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          counterStyle: TextStyle(
                            color: Colors.white,
                            fontSize: wi * .03,
                          ),
                          labelText: "جستجو",
                          labelStyle: TextStyle(
                              fontSize: wi * .035, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                // constraints: BoxConstraints(minHeight: he * .1),
                height: he * .05,
                margin: EdgeInsets.only(
                    left: wi * .07, right: wi * .07, top: he * .05),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cats.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          active = index;
                        });
                        getDetailProduct(index);
                      },
                      child: Container(
                        constraints: BoxConstraints(minHeight: he * .25),
                        padding: EdgeInsets.symmetric(horizontal: wi * .02),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: active == index
                              ? const Color(0x4EC2BFBF)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            cats[index]['category'],
                            style: TextStyle(
                                fontFamily: 'sans',
                                color: active == index
                                    ? const Color(0xFFDCE1E3)
                                    : Colors.blueGrey[600]),
                          ),
                        ),
                      ),
                    );
                  },
                )),
            Container(
              margin: const EdgeInsets.only(top: 30),
              height: he * .596,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                  itemCount: prods.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                        left: wi * .07,
                        top: wi * .04,
                        right: wi * .07,
                      ),
                      width: wi * .8,
                      height: he * .27,
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Colors.pink[100]?.withOpacity(.7)
                            : const Color(0xFF7c9998),
                        borderRadius: BorderRadius.circular(23),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            blurRadius: 8,
                            spreadRadius: .4,
                            offset: const Offset(2, 4),
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ItemDetail(
                                productName:
                                    prods[index]['proTitle'].toString(),
                                productCate: cats[index]['category'].toString(),
                                productImg: prods[index]['proImg'].toString(),
                                productPrice:
                                    prods[index]['proDesc'].toString(),
                                productDesc:
                                    prods[index]['proPrice'].toString(),
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: wi * .01),
                              width: wi,
                              height: he,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(23),
                                  bottomLeft: Radius.circular(23),
                                  topRight: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                ),
                              ),
                            ),
                            Container(
                              width: wi,
                              height: he,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    constraints:
                                        BoxConstraints(minWidth: wi * .25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            prods[index]['proTitle'].toString(),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: wi * .04),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            prods[index]['category'],
                                            style: TextStyle(
                                                color: Colors.blueGrey[700]),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            prods[index]['proPrice'].toString(),
                                            style: TextStyle(
                                              color: index.isEven
                                                  ? Colors.pink[300]
                                                      ?.withOpacity(.7)
                                                  : const Color(0xFF7c9998),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: wi * .26,
                                    height: he * .18,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            prods[index]['proImg']),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      )),
    );
  }

  Widget NavItem(wi, he, IconData icon, int id) {
    return InkWell(
      onTap: () {
        if (id == 1) {
          Navigator.of(context).pop();
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => const Profile(),
              transitionDuration: Duration(seconds: 1)));
        } else if (id == 2) {
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Checkout()));
        } else {
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const About()));
        }
      },
      child: id != 1
          ? Container(
              padding: EdgeInsets.all(wi * .03),
              margin: EdgeInsets.only(bottom: wi * .02),
              decoration: const BoxDecoration(
                color: Color(0xFF7c9998),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ))
          : Hero(
              tag: "tae",
              child: Container(
                width: wi * .1,
                height: he * .1,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: wi * .006),
                decoration: const BoxDecoration(
                  color: Color(0xFF7c9998),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "data:image/jpeg;base64,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"),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
    );
  }
}
