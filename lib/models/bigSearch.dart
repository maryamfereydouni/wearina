import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wearina/models/item_detail.dart';

class bigSearch extends StatefulWidget {
  const bigSearch({super.key});

  @override
  State<bigSearch> createState() => _bigSearchState();
}

class _bigSearchState extends State<bigSearch> {
  List prods = [];
  String process = "محصول مورد نظز خود را جستجو کنید";
  TextEditingController search = TextEditingController();

  getData() async {
    await http.post(Uri.http("http://127.0.0.1:3000/search"),
        body: {"phrase": search.text.trim()}).then((res) {
      var body = jsonDecode(res.body);
      if (body['products'].toString().isEmpty) {
        setState(() {
          process = "محصولی یافت نشد ";
        });
      } else if (body['products'].toString().isNotEmpty) {
        print(body['categories'].toString() + "\n");
        setState(() {
          prods = body['products'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: wi,
          height: he,
          child: ListView(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(
                  top: wi * .05,
                  left: wi * .05,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.pink[400],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: wi * .08,
                right: wi * .08,
                top: he * .05,
              ),
              height: he * .2,
              child: Hero(
                tag: 'search',
                child: Material(
                  type: MaterialType.transparency,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      maxLength: 30,
                      controller: search,
                      textDirection: TextDirection.rtl,
                      cursorColor: Colors.blueGrey[800],
                      decoration: InputDecoration(
                        counterStyle:
                            TextStyle(color: Colors.grey, fontSize: wi * .03),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: "جستجو",
                        labelStyle: TextStyle(
                          fontSize: wi * .035,
                          color: Colors.pink[400],
                          fontFamily: 'sans',
                        ),
                        prefixIcon: InkWell(
                          onTap: () {
                            getData();
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            prods != null && prods.length != 0
                ? Container(
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
                                      productCate:
                                          prods[index]['category'].toString(),
                                      productImg:
                                          prods[index]['proImg'].toString(),
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
                                          constraints: BoxConstraints(
                                              minWidth: wi * .25),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child: Text(
                                                  prods[index]['proTitle']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: wi * .04),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  prods[index]['categories'],
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueGrey[700]),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  prods[index]['proPrice']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: index.isEven
                                                        ? Colors.pink[300]
                                                            ?.withOpacity(.7)
                                                        : const Color(
                                                            0xFF7c9998),
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
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                  )
                : Center(
                    child: Text(process),
                  ),
          ]),
        ),
      ),
    );
  }
}
