import 'dart:async';
import 'dart:convert';
import 'package:ChaTho_Anatomy/models/ListResponseModel.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/Tissue_Details.dart';
import 'package:ChaTho_Anatomy/utilities/ReloadPage.dart';
import 'package:ChaTho_Anatomy/widgets/LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/screens/tissue_add.dart';
import 'package:ChaTho_Anatomy/screens/tissue_detail.dart';

class TissueList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TissueListState();
  }
}

class _TissueListState extends State {

  List<TissueDetails> tissueDetails;
  Tissue selectedTissue;
  var txtName = TextEditingController();
  Map<String,bool> results={"tissues":false};
  Function reloader;

  @override
  void initState() {
    reloader = ()=>ReloadPage.reloadPage(context, TissueList());
    getTissueDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (results.values.contains(false) ? false:true) {
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
                  1.5),
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
      return LoadingPage(reloader,results);
    }
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

  Future getTissueDetails() async {
    await TissueApi.getTissueDetails().then((response) {
      setState(() {
        var jsonMap = json.decode(response.body);
        ListResponseModel listResponseModel =
            new ListResponseModel.fromJson(jsonMap);
        var list = listResponseModel.dataList;
        this.tissueDetails =
            list.map((e) => TissueDetails.fromJson(e)).toList();
        setState(() {
          results["tissues"]=true;
        });
      });
    });
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

  void goToDetail(TissueDetails tissueDetails) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TissueDetail(tissueDetails)));
  }
}
