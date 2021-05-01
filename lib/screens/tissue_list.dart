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
  bool result = false;
  int timer = 5;

  @override
  void initState() {
    getTissueDetails().then((response) => setState(() {
          result = true;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (result) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tissue List"),
          backgroundColor: Colors.black87,
          centerTitle: true,
        ),
        body: buildTissueList(),
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
      return Scaffold(
          body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            SpinKitFoldingCube(
              color: Colors.black,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            timer == 0
                ? buildTryButton()
                : SizedBox(
                    child: Text("Getting data... " + timer.toString()),
                  ),
          ],
        ),
      ));
    }
  }

  startTimer() {
    Timer.periodic(Duration(seconds: 1), (result) {
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
        child: Text("Try again"),
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // background
          onPrimary: Colors.black, // foreground
        ));
  }

  reloadPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TissueList()));
  }

  buildTissueList() {
    return GridView.count(
        crossAxisCount: 2,
        children: List.generate(tissueDetails.length, (index) {
          return Card(
            color: Colors.black87,
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  (this.tissueDetails[index].id).toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              title: Text(
                this.tissueDetails[index].name,
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(this.tissueDetails[index].sort,
                  style: TextStyle(
                    color: Colors.white38,
                  ),
                  textAlign: TextAlign.center),
              onTap: () {
                goToDetail(this.tissueDetails[index]);
              },
            ),
          );
        }));
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
