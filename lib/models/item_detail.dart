import 'package:flutter/material.dart';
import 'package:wearina/pages/main_screen/main_screen.dart';

class ItemDetail extends StatefulWidget {
  final String productName;
  final String productCate;
  final String productImg;
  final String productPrice;
  final String productDesc;
  const ItemDetail(
      {required this.productName,
      required this.productCate,
      required this.productPrice,
      required this.productImg,
      required this.productDesc,
      super.key});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  int active = 0;

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Colors.brown[400]?.withOpacity(.5),
        width: wi,
        height: he,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: he * .02, top: wi * .03),
                width: wi,
                height: he * .37,
                child: Image.network(widget.productImg),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(right: wi * .07, top: he * .04),
                child: Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                  size: wi * .05,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: wi * .07, top: he * .04),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: wi * .05,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: wi,
                height: he * .5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: he * .14,
                        left: wi * .1,
                        right: wi * .1,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(widget.productName),
                          ),
                          Container(
                            child: Text(widget.productCate),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: wi * .1,
                        right: wi * .1,
                        top: wi * .02,
                      ),
                      child: Text(
                        widget.productDesc,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("object");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: wi * .01),
                        margin: EdgeInsets.symmetric(
                            horizontal: wi * .4, vertical: wi * .05),
                        decoration:
                            BoxDecoration(color: Color(0xFF7c9998), boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.5),
                            blurRadius: 13,
                            spreadRadius: 1,
                            offset: Offset(2, 4),
                          ),
                        ]),
                        child: const Center(
                          child: Text("more"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: wi,
                height: he * .15,
                decoration: const BoxDecoration(
                  color: Color(0xFF7c9998),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: wi * .12),
                  width: wi,
                  height: he,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            widget.productPrice + "تومان",
                            style: TextStyle(
                                color: Colors.white, fontSize: wi * .042),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          height: he * .065,
                          decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Text(
                            "Buy",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: wi * .033),
                          )),
                        ),
                      ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: wi * .78,
                height: he * .2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                        offset: Offset(0, 15),
                      ),
                    ]),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.productImg.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            active = index;
                          });
                        },
                        child: AnimatedOpacity(
                          curve: Curves.fastOutSlowIn,
                          duration: Duration(microseconds: 500),
                          opacity: active == index ? 1 : .3,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: wi * .03, vertical: wi * .05),
                            width: wi * .15,
                            height: he * .1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.productImg),
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
