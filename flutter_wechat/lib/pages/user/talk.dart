import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import './detailed.dart';

class Talk extends StatefulWidget{
  Talk({Key key, this.detail}) : super(key: key);
  final detail;

  @override
  _TalkState createState() => new _TalkState();
}

class _TalkState extends State<Talk> with SingleTickerProviderStateMixin{
  var fsNode1 = new FocusNode();
  var _textInputController = new TextEditingController();
  var _scrollController = new ScrollController();
  List<Widget> talkWidgetList = <Widget>[];
  List<Map> talkHistory = [];
  bool talkFOT = false;
  bool otherFOT = false;

  Animation animationTalk;
  AnimationController controller;

    @override
    void initState() {
      controller = new AnimationController(duration: new Duration(seconds: 1), vsync: this);
      animationTalk = new Tween(begin: 1.0, end: 1.5).animate(controller)
      ..addStatusListener((state){
        if(state == AnimationStatus.completed) {
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

      fsNode1.addListener(_focusListener);

      super.initState();
    }

    _focusListener() async {
      if (fsNode1.hasFocus) {
        setState(() {
          otherFOT = false;
          talkFOT = false;
        });
      }
    }

  @override
    void dispose() {
      // TODO: implement dispose
      controller.dispose();
      super.dispose();
    }


  List<String> returnTalkList = [
    '这是自动留言,我的手机不在身边, 有事请直接Call我....',
    '呵呵,真好笑!!!',
    '你最近好吗?',
    '如果我是DJ你会爱我吗?',
    'hohohohohoho, boom!',
    '刮风那天我试过牵着你手',
  ];

  getTalkList() {
    List<Widget> widgetList = [];

    for(var i = 0; i < talkHistory.length; i ++) {
      widgetList.add(returnTalkItem(talkHistory[i]));
    }

    setState(() {
      talkWidgetList = widgetList;
//      _scrollController.animateTo( 50.0 * talkHistory.length + 100,duration: new Duration(seconds: 1), curve: Curves.ease);
    });
  }

void  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      autoTalk(image, 'image');
    }
  }

  autoTalk(val, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mySelf = json.decode(prefs.getString('userInfo'));
    
    talkHistory.add({
      'name': mySelf['name'],
      'id': mySelf['id'],
      'imageUrl': mySelf['imageUrl'],
      'content': val,
      'type': type // image text
    });
    getTalkList();

    Future.delayed(new Duration(seconds: 1), (){
      var item = {
          'name': widget.detail['name'],
          'id': widget.detail['id'],
          'imageUrl': widget.detail['imageUrl'],
          'content': returnTalkList[talkHistory.length % 5],
          'type': 'text'
        };
       talkHistory.add(item);
       getTalkList();
    });
  }

  returnTalkType(type, val) {
    switch(type) {
      case 'text':
        return new Text(val,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 100,
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      height: 1,
                    )
        );
      break;
      case 'image':
        return new Image.file(val);
      break;
      case 'text':
        return new Text(val);
      break;
    }
  }


  returnTalkItem(item) {
    List<Widget> widgetList = [];

    if(item['id'] != widget.detail['id']){
      // 非本人的信息
      widgetList = [
          new Container(
              margin: new EdgeInsets.only(right: 20.0),
              padding: new EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                color: Color(0xFFebebf3),
                borderRadius: new BorderRadius.circular(10.0)
              ),
              child: new LimitedBox(
                maxWidth: MediaQuery.of(context).size.width - 120.0,
                child: returnTalkType(item['type'], item['content']),
              )
          ),
          new CircleAvatar(
            backgroundImage: new NetworkImage('${item['imageUrl']}'),
          ),
      ];
    } else {
      // 本人的信息
      widgetList = [
          new CircleAvatar(
            backgroundImage: new NetworkImage('${item['imageUrl']}'),
          ),
          new Container(
              margin: new EdgeInsets.only(left: 20.0),
              padding: new EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                color: Color(0xFFebebf3),
                borderRadius: new BorderRadius.circular(10.0)
              ),
              child: new LimitedBox(
                maxWidth: MediaQuery.of(context).size.width - 120.0,
                child: returnTalkType(item['type'], item['content'])
              ),
          ),
      ];
    }

    return new Container(
        width: MediaQuery.of(context).size.width - 120.0,
        margin: new EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          mainAxisAlignment: widget.detail['id'] == item['id'] ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgetList
        )
    );
  }

  Widget getRecEditText(BuildContext context) =>
      new Container(
        width: MediaQuery.of(context).size.width-107,
        padding: new EdgeInsets.symmetric(horizontal: 10.0),
        child: new TextField(
          focusNode: fsNode1,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 15.0),
            hintText: '友善发言的人运气都不会差',
//            prefixIcon: Icon(Icons.search),
            // contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: const Color(0xFFCCCCCC))),
            filled: true,
            fillColor: Color(0xffffffff),
          ),
        ),
      );

  get sendText =>
      new Text("发送",
          style: const TextStyle(color: const Color(0xFFF6A637), fontSize: 15));


  get gestureDetector =>
      new GestureDetector(
        child: sendText,
        onTap: () {
        },
      );

  Widget getEditRowWidget(BuildContext context) {


    var row = new Row(
      children: <Widget>[
        getRecEditText(context),
        gestureDetector,
      ],
    );


    var column = Column(children: <Widget>[
      row
    ],);
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.only(top: 10,bottom: 17),
      child: column,
    );
  }


  @override
  Widget build(BuildContext context){

    var appBar2 = new AppBar(
          leading: new IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: (){
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          title: new Text('${widget.detail['name']}', style: new TextStyle(fontSize: 20.0),),
          actions: <Widget>[
            new IconButton(
              icon: Icon(Icons.person, size:30.0),
              onPressed: (){
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (_) => new Detailed(detail: widget.detail)
                  )
                );
              },
            )
          ],
          centerTitle: true,
        );
    return new WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
      },
      child:  new Scaffold(
        appBar: appBar2,
        body: new Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 20.0),
                padding: new EdgeInsets.only(bottom: 50.0),
                // width: MediaQuery.of(context).size.width - 40.0,
                child: ListView(
                  controller: _scrollController,
                  children: talkWidgetList,
                ),
              ),
              new Positioned(
                bottom: 0,
                left:0,
                width: MediaQuery.of(context).size.width,
                child: getEditRowWidget(context),
              )
            ],
          )
        ),
      ),
    );
  }
}