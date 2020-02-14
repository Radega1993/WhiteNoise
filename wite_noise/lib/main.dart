import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'WhiteNoise',
      home: new Home(),
      theme: new ThemeData(primaryColor: Colors.blue),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var spacecrafts = ["Rain", "Fontain"];
    var imagesBack = ['assets/images/rain.jpg', 'assets/images/fuente.jpg'];
    var myGridView = new GridView.builder(
      itemCount: spacecrafts.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new Card(
            elevation: 5.0,
            child: new Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                  image: new AssetImage(imagesBack[index]),
                  fit: BoxFit.fill,
                )),
                alignment: Alignment.center,
                margin:
                    new EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                child: new Text(
                  spacecrafts[index],
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                )
            ),
          ),
          onTap: () {
            //add player
          },
        );
      },
    );

    return new Scaffold(
      appBar: new AppBar(title: new Text("WhiteNoise")),
      body: myGridView,
    );
  }
}

void main() {
  debugPaintSizeEnabled = false; // Set to true for visual layout
  runApp(new MyApp());
}
