import 'dart:convert';
import 'package:ChaTho_Anatomy/models/ListResponseModel.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/Tissue_Details.dart';
import 'package:flutter/material.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
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
  List<TissueDetails> tissueDetails;
  Tissue detailTissue;
  int tissueCount = 0;

  @override
  void initState() {
    getTissueDetails();
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

  buildTissueList() {
    return GridView.count(
        crossAxisCount: 2,
        children: List.generate(tissueDetails.length, (index) {
          return Card(
            color: Colors.black54,
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black38,
                child: Text((this.tissueDetails[index].id).toString()),
              ),
              title: Text(this.tissueDetails[index].name),
              subtitle: Text(
                this.tissueDetails[index].sort,
                style: TextStyle(color: Colors.white38),
              ),
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

  void getTissueDetails() async {
    TissueApi.getTissueDetails().then((response) {
      setState(() {
        var jsonMap = json.decode(response.body);
        ListResponseModel listResponseModel =
            new ListResponseModel.fromJson(jsonMap);
        var list = listResponseModel.dataList;
        this.tissueDetails =
            list.map((e) => TissueDetails.fromJson(e)).toList();
        this.tissueCount = this.tissueDetails.length;
      });
    });
  }

  void goToDetail(TissueDetails tissueDetails) async {
    await getTissueById(tissueDetails.id);
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TissueDetail(tissueDetails, detailTissue)));
    if (result != null) {
      if (result) {
        getTissueDetails();
      }
    }
  }

  Future getTissueById(int id) async {
    await TissueApi.getTissueById(id).then((response) {
      var jsonMap = json.decode(response.body);
      ResponseModel<Tissue> responseModel = new ResponseModel(data: new Tissue.fromJson(jsonMap['data']));
      detailTissue = responseModel.data;
    });
  }
}
