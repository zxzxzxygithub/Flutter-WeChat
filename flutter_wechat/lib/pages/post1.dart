import 'package:flutter/material.dart';

class Post1 extends StatefulWidget {
  @override
  _Post1State createState() => _Post1State();
}

class _Post1State extends State<Post1> {

  var fsNode1 = new FocusNode();
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

  String get smapleUrl =>
      "https://1251250874.vod2.myqcloud.com/439f276avodtransgzp1251250874/7e2220e95285890783697823989/v.f20.mp4";


  void showGoodsView() {
    setState(() {
      show = true;
    });
  }

  _focusListener() async {
    if (fsNode1.hasFocus) {
      setState(() {
        _scrollController.animateTo(1000,duration: new Duration(seconds: 1), curve: Curves.ease);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fsNode1.addListener(_focusListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // todo make it custom
  get appBar => AppBar(
    leading: GestureDetector(child: Icon(Icons.arrow_back_ios, size: 22,color: Colors.black,), onTap: (){ },),
    elevation: 0,
    backgroundColor: Colors.white,
    title: Text('动态详情', style: TextStyle(color: Color(0xFF333333)),),
    centerTitle: true,
    actions: <Widget>[
      Padding(padding:EdgeInsets.only(right: 10),child: GestureDetector(
        child:Image.asset('images/icon_share_black.png',width: 35, height: 35,),
        onTap: (){ },
      )) ,
    ],
  );


  var show = false;

  var _scrollController = new ScrollController();
  List<Widget> talkWidgetList = <Widget>[];
  Widget getStack() {
    var container = Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            child:ListView(children: talkWidgetList,),),
          Positioned(
               bottom: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: getEditRowWidget(context)),
  //             child: getEditRowWidget(context)),
        ],
    ),);
    return container;
  }


//  get body => getStack();
  get body =>  Container(
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
  );

  Widget scaffold(context) =>  Scaffold(
    resizeToAvoidBottomPadding: false,
//    appBar: appBar,
    appBar: AppBar(
      leading: new IconButton(
        icon: Icon(Icons.keyboard_arrow_left),
        onPressed: (){
          Navigator.of(context).pushReplacementNamed('/home');
        },
      ),
      title: new Text('name', style: new TextStyle(fontSize: 20.0),),
      actions: <Widget>[
        new IconButton(
          icon: Icon(Icons.person, size:30.0),
          onPressed: (){
          },
        )
      ],
      centerTitle: true,
    ),
    body: body,
  );

  @override
  Widget build(BuildContext context) {
    return originalScaffold(context);
//    return timeScaffold(this);
  }

  Widget originalScaffold(BuildContext context) => scaffold(context);

}
