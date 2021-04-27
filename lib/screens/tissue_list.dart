import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/response_model.dart';
import 'package:ChaTho_Anatomy/screens/tissue_add.dart';
import 'package:ChaTho_Anatomy/screens/tissue_detail.dart';

class TissueList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TissueListState();
  }
}

class _TissueListState extends State {
  List<Tissue> tissues;
  int tissueCount = 0;

  @override
  void initState() {
    getTissues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tissue List"),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: buildTissueList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          goToTissueAdd();
        },
        child: Icon(Icons.add),
        tooltip: "Add New Tissue",
      ),
    );
  }

  ListView buildTissueList() {
    return ListView.builder(
      itemCount: tissueCount,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.black54,
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black38,
              child: Text("a"),
            ),
            title: Text(this.tissues[position].name),
            subtitle: Text((this.tissues[position].sortId).toString(),style: TextStyle(color: Colors.white38),),
            onTap: () {
              goToDetail(this.tissues[position]);
            },
          ),
        );
      },
    );
  }

  void goToTissueAdd() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TissueAdd()));
    if (result != null) {
      if (result) {
        getTissues();
      }
    }
  }

  void getTissues() async {
    TissueApi.getTissues().then((response) {
      setState(() {
        var jsonMap = json.decode(response.body);
        ResponseModel responseModel = new ResponseModel.fromJson(jsonMap);
        this.tissues = responseModel.data;
        this.tissueCount=this.tissues.length;
        //getTissueWidgets();
      });
    });
  }

  void goToDetail(Tissue tissue) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TissueDetail(tissue)));
    if (result != null) {
      if (result) {
        getTissues();
      }
    }
  }
}
