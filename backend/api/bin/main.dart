// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';
import 'package:angel_hot/angel_hot.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:angel_framework/angel_framework.dart';

main() async {
  var hot = HotReloader(createServer, ['main.dart']);
  await hot.startServer('192.168.1.106', 8383);
}

Future<Angel> createServer() async {
  var app = Angel();
  app.logger = Logger('Log...')..onRecord.listen((events) => print(events));
  var db = Db('mongodb://localhost:27017/wearina');
  await db.open();
  var uuid = Uuid();

  var usersColl = db.collection('users');

  app.post('/signup', (req, res) async {
    await req.parseBody();
    var name = req.bodyAsMap['name'] as String;
    var email = req.bodyAsMap['email'] as String;
    var phone = req.bodyAsMap['phone'] as String;
    var pass = req.bodyAsMap['pass'] as String;
    // var image = req.bodyAsMap['image'] as String;
    // var imagename = req.bodyAsMap['imagename'] as String;
    res.headers['content-type'] = 'application/json';
    res.headers['Accept-Charset'] = 'utf-8';
    res.headers['Access-Control-Allow-Headers'] =
        'Access-Control-Allow-Origin, Accept';

    // var realFile = base64Decode(image);
    if (await usersColl.findOne(where.eq('username', name)) == null &&
        await usersColl.findOne(where.eq('phone', phone)) == null) {
      await usersColl.insert({
        'uuid': uuid.v4(),
        'username': name,
        'useremail': email,
        'phone': phone,
        'passwd': pass,
        // 'image':
        //     'http://127.0.0.1/images/$imagename ${DateTime.now().toString()}.jpg',
      }).then((value) {
        // if (value.isNotEmpty) {
        // File('../images/$imagename.jpg').createSync();
        // File('../images/$imagename.jpg').writeAsBytesSync(realFile);
        // }
        res.write(jsonEncode({
          'success': true,
          'message': 'user created',
          'uuid': value['uuid'],
        }));
      });
    } else {
      res.write(jsonEncode({
        'success': false,
        'message': 'user exist',
      }));
    }
  });

  app.post('/signin', (req, res) async {
    await req.parseBody();
    var name = req.bodyAsMap['name'] as String;
    var pass = req.bodyAsMap['pass'] as String;
    res.headers['content-type'] = 'application/json';
    res.headers['Accept-Charset'] = 'utf-8';
    res.headers['Access-Control-Allow-Headers'] =
        'Access-Control-Allow-Origin, Accept';

    if (await usersColl.findOne(where.eq('username', name)) == null) {
      res.write(jsonEncode({
        'success': false,
        'message': 'User does not exist...',
      }));
    } else {
      var user = await usersColl
          .findOne(where.eq('passwd', pass).and(where.eq('username', name)));
      if (user.isNotEmpty) {
        res.write(jsonEncode({
          'success': true,
          'message': 'user exists...',
          'uuid': user['uuid'],
        }));
      }
    }
  });

  app.get('/getProducts', (req, res) async {
    var prodColl = DbCollection(db, 'products');

    var cateColl = DbCollection(db, 'categories');

    List cats = await cateColl.find().toList();
    List prods = await prodColl.find().toList();

    res.headers['content-type'] = 'application/json';
    res.headers['Accept-Charset'] = 'utf-8';
    res.headers['Access-Control-Allow-Headers'] =
        'Access-Control-Allow-Origin, Accept';
    res.write(jsonEncode({
      'categories': cats,
      'products': prods,
      'headers': res.headers.toString(),
      'sent headers': res.headers.toString()
    }));
  });

  app.post('/getDetails', (req, res) async {
    var prodColl = DbCollection(db, 'products');

    await req.parseBody();
    var uid = req.bodyAsMap['uid'] as String;
    var singleProduct = await prodColl.findOne(where.eq('uuid', uid));
    res.headers['content-type'] = 'application/json';
    res.headers['Accept-Charset'] = 'utf-8';
    res.headers['Access-Control-Allow-Headers'] =
        'Access-Control-Allow-Origin, Accept';

    res.write(jsonEncode({
      'description': singleProduct['prodDesc'],
    }));
  });

  app.post('/getCatProds', (req, res) async {
    await req.parseBody();
    var uid = req.bodyAsMap['uuid'] as String;
    var prodColl = DbCollection(db, 'products');

    List products = await prodColl.find(where.eq('categoryID', uid)).toList();
    res.headers['content-type'] = 'application/json';
    res.headers['Accept-Charset'] = 'utf-8';
    res.headers['Access-Control-Allow-Headers'] =
        'Access-Control-Allow-Origin, Accept';

    res.write(jsonEncode({
      'success': true,
      'products': products,
    }));
  });

  app.post('/getProfile', (req, res) async {
    await req.parseBody();
    var uid = req.bodyAsMap['uid'] as String;
    var user = await usersColl.findOne(where.eq('uuid', uid));
    List purchases = user['purches'] ?? [];
    res.headers['content-type'] = 'application/json';
    res.headers['Accept-Charset'] = 'utf-8';
    res.headers['Access-Control-Allow-Headers'] =
        'Access-Control-Allow-Origin, Accept';

    res.write(jsonEncode({
      'success': true,
      'username': user['username'],
      'image': user['image'],
      'purches': purchases,
    }));
  });

  app.post('/search', (req, res) async {
    await req.parseBody();
    var prodColl = DbCollection(db, 'products');
    var uid = req.bodyAsMap['uid'] as String;
    var user = await usersColl.findOne(where.eq('uuid', uid));

    List result = await prodColl
        .find(where
            .match('prodTitle', user['phrase'])
            .or(where.match('prodDesc', user['phrase'])))
        .toList();
    res.headers['content-type'] = 'application/json';
    res.headers['Accept-Charset'] = 'utf-8';
    res.headers['Access-Control-Allow-Headers'] =
        'Access-Control-Allow-Origin, Accept';

    res.write(jsonEncode({
      'success': true,
      'products': result,
    }));
  });

  // app.post('/pay', (req, res) async {});

  return app;
}
