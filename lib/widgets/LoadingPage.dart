import 'dart:async';

import 'package:ChaTho_Anatomy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage(this.reloader,this.results);

  Function reloader;
  Map<String,bool> results;

  @override
  State<StatefulWidget> createState() {
    return _LoadingPageState();
  }
}

class _LoadingPageState extends State<LoadingPage>{

  @override
  void initState() {
    startTimer();
    reloadPage = widget.reloader;
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Function reloadPage;
  Timer _timer;
  int timer = Constants.timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Image.asset(
                "assets/images/logo.png",
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              timer == 0
                  ? buildTryButton()
                  : SpinKitFoldingCube(
                color: Colors.black,
                size: 60,
              ),
            ],
          ),
        ));
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (result) {
      setState(() {
        timer--;
      });
      if (timer == 0 || !widget.results.values.contains(false)) {
        result.cancel();
      }
    });
  }

  buildTryButton() {
    return ElevatedButton(
        onPressed: ()=>reloadPage.call(),
        child: Text("Try again", style: TextStyle(fontFamily: 'BebasNeue')),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.3,
              MediaQuery.of(context).size.height * 0.07),
          primary: Colors.white, // background
          onPrimary: Colors.black, // foreground
        ));
  }

}
