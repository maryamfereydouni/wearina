import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:wearina/models/signupin.dart';
import 'package:wearina/pages/main_screen/main_screen.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: wi,
        height: he,
        child: IntroViewsFlutter(
          skipText: Text(
            "رد کن...",
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'sans'),
          ),
          doneText: Text(
            "گرفتم!",
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'sans'),
          ),
          onTapDoneButton: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (f) => SignUpIn()));
          },
          [
            PageViewModel(
                body: Text(
                  "این متن بدنه صفحه اول است",
                  style: TextStyle(fontFamily: 'sans', fontSize: wi * .035),
                ),
                pageColor: Colors.blue,
                title: Text(
                  "این متن صفحه ی اول توضیحات است",
                  style: TextStyle(fontFamily: 'sans', fontSize: wi * .035),
                ),
                mainImage: Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: wi * .3,
                ),
                bubbleBackgroundColor: Colors.white),
            PageViewModel(
                body: Text(
                  "این متن بدنه صفحه دوم است",
                  style: TextStyle(fontFamily: 'sans', fontSize: wi * .035),
                ),
                pageColor: Colors.purple,
                title: Text(
                  "این متن صفحه ی دوم توضیحات است",
                  style: TextStyle(fontFamily: 'sans', fontSize: wi * .035),
                ),
                mainImage: Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: wi * .3,
                ),
                bubbleBackgroundColor: Colors.grey),
            PageViewModel(
                body: Text(
                  "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام ",
                  style: TextStyle(fontFamily: 'sans', fontSize: wi * .035),
                  textDirection: TextDirection.rtl,
                ),
                pageColor: Colors.indigo,
                title: Text(
                  "صفحه سوم",
                  style: TextStyle(fontFamily: 'sans', fontSize: wi * .035),
                ),
                mainImage: Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: wi * .3,
                ),
                bubbleBackgroundColor: Colors.black),
          ],
        ),
      ),
    );
  }
}
