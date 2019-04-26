import 'package:flutter/material.dart';

import './pages/home/home.dart';
import './pages/sign/signIn.dart';
import 'pages/user/talk1.dart';

main(){
  return runApp(new MyWeChat());
}

class MyWeChat extends StatefulWidget{
  @override

  _MyWeChatState createState() => new _MyWeChatState();
}

class _MyWeChatState extends State<MyWeChat>{
  get testMap => {
    'name': 'kuaifengle',
    'id': 1,
    'checkInfo': 'https://github.com/kuaifengle',
    'lastTime': '20.11',
    'imageUrl': 'https://image.lingcb.net/goods/201812/2ad6f1b0-2b2c-4d71-8d0d-01679e298afc-150x150.png',
    'backgroundUrl': 'http://pic31.photophoto.cn/20140404/0005018792087823_b.jpg'
  };

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Flutter仿微信',
      theme: new ThemeData(
        primaryColorBrightness: Brightness.dark,
        primaryColor: const Color(0xFF64c223),
        hintColor: const Color(0xFFcfcfcf),
        iconTheme: new IconThemeData(
          color: Colors.white
        ),
      ),
      home: new Talk(detail: testMap,),
      routes: <String, WidgetBuilder>{
        '/home': (_) => new Home(),
        '/signIn': (_) => new SignIn()
      }
    );
  }
}