import 'dart:async';
import 'dart:convert';
import 'package:ChaTho_Anatomy/models/ListResponseModel.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/Tissue_Details.dart';
import 'package:flutter/material.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/screens/tissue_add.dart';
import 'package:ChaTho_Anatomy/screens/tissue_detail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TissueList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TissueListState();
  }
}

class _TissueListState extends State {
  _TissueListState() {
    startTimer();
  }

  List<TissueDetails> tissueDetails;
  Tissue selectedTissue;
  var txtName = TextEditingController();
  bool result = false;
  Timer _timer;
  int timer = 10;

  @override
  void initState() {
    getTissueDetails().then((response) => setState(() {
          result = true;
        }));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (result) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tissue List", style: TextStyle(fontFamily: 'BebasNeue')),
          backgroundColor: Colors.black87,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.15,
                  5,
                  MediaQuery.of(context).size.width * 0.15,
                  0),
              child: buildNameField(),
            ),
            buildTissueList()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () {
            goToTissueAdd();
          },
          child: Icon(Icons.add),
          tooltip: "Add New Tissue",
        ),
      );
    } else {
      return buildLoadingPge();
    }
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (result) {
      setState(() {
        timer--;
        if (timer == 0) {
          result.cancel();
        }
      });
    });
  }

  buildTryButton() {
    return ElevatedButton(
        onPressed: reloadPage,
        child: Text("Try again", style: TextStyle(fontFamily: 'BebasNeue')),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.3,
              MediaQuery.of(context).size.height * 0.07),
          primary: Colors.white, // background
          onPrimary: Colors.black, // foreground
        ));
  }

  reloadPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TissueList()));
  }

  buildLoadingPge(){
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

  TextField buildNameField() {
    return TextField(
      cursorColor: Colors.black,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          contentPadding: new EdgeInsets.symmetric(vertical: 10),
          labelText: "Tissue Name",
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          )),
      controller: txtName,
    );
  }

  buildTissueList() {
    List<TissueDetails> list;
    setState(() {
      list=tissueDetails.where((t) => t.name.toLowerCase().contains(txtName.text.toLowerCase())).toList();
    });

    return Expanded(
      child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(list.length, (index) {
            return Card(
              color: Colors.black87,
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Text(
                    (list[index].id).toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'BebasNeue'),
                  ),
                ),
                title: Text(
                  list[index].name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(list[index].sort,
                    style: TextStyle(
                      color: Colors.white38,
                    ),
                    textAlign: TextAlign.center),
                onTap: () {
                  goToDetail(list[index]);
                },
              ),
            );
          })),
    );
  }

  void goToTissueAdd() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TissueAdd()));
    if (result != null) {
      if (result) {
        getTissueDetails();
      }
    }
  }

  Future getTissueDetails() async {
    await TissueApi.getTissueDetails().then((response) {
      setState(() {
        var jsonMap = json.decode(response.body);
        ListResponseModel listResponseModel =
            new ListResponseModel.fromJson(jsonMap);
        var list = listResponseModel.dataList;
        this.tissueDetails =
            list.map((e) => TissueDetails.fromJson(e)).toList();
      });
    });
  }

  void goToDetail(TissueDetails tissueDetails) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TissueDetail(tissueDetails)));
  }
}
