import 'dart:convert';

import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/Tissue_Details.dart';
import 'package:ChaTho_Anatomy/models/response_model.dart';
import 'package:flutter/material.dart';

class TissueDetail extends StatefulWidget {
  TissueDetail(this.tissueDetail);

  TissueDetails tissueDetail;

  @override
  State<StatefulWidget> createState() {
    return _TissueDetailState();
  }
}

enum Options { delete, update }

class _TissueDetailState extends State<TissueDetail> {
  //_TissueDetailState(this.tissue);

  //Tissue tissue;
  var txtName = TextEditingController();
  var txtSort = TextEditingController();
  var txtRegion = TextEditingController();
  var txtGender = TextEditingController();
  var txtOrigin = TextEditingController();

  @override
  void initState() {
    txtName.text = widget.tissueDetail.name;
    txtRegion.text = widget.tissueDetail.region;
    txtSort.text = widget.tissueDetail.sort;
    txtGender.text = widget.tissueDetail.gender;
    txtOrigin.text = widget.tissueDetail.origin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text("Tissue Detail : ${widget.tissueDetail.name}"),
        actions: <Widget>[
          PopupMenuButton<Options>(
            onSelected: selectProcess,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
              PopupMenuItem<Options>(
                value: Options.delete,
                child: Text("Delete"),
              ),
              PopupMenuItem<Options>(
                value: Options.update,
                child: Text("Update"),
              )
            ],
          )
        ],
      ),
      body: buildTissueDetail(),
    );
  }

  buildTissueDetail() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
          buildNameField(),
          buildSortField(),
          buildRegionField(),
          buildGenderField()
        ],
      ),
    );
  }

  TextField buildNameField() {
    return TextField(
      decoration: InputDecoration(labelText: "Tissue Name"),
      controller: txtName,
    );
  }

  TextField buildRegionField() {
    return TextField(
      decoration: InputDecoration(labelText: "Tissue Region"),
      controller: txtRegion,
    );
  }

  TextField buildSortField() {
    return TextField(
      decoration: InputDecoration(labelText: "Tissue Sort"),
      controller: txtSort,
    );
  }

  TextField buildGenderField() {
    return TextField(
      decoration: InputDecoration(labelText: "Tissue Gender"),
      controller: txtGender,
    );
  }

  TextField buildOriginField() {
    return TextField(
      decoration: InputDecoration(labelText: "Tissue Origin"),
      controller: txtOrigin,
    );
  }

  void selectProcess(Options value) async {
    switch (value) {
      case Options.delete:
        //await dbHelper.delete(tissue.id);
        Navigator.pop(context, true);
        break;
      case Options.update:
        List<Tissue> updatedTissue;
        TissueApi.getTissueById(widget.tissueDetail.id).then((response) {
          setState(() {
            var jsonMap = json.decode(response.body);
            ResponseModel responseModel = new ResponseModel.fromJson(jsonMap);
            var list=responseModel.data;
             updatedTissue= list.map((e) => Tissue.fromJson(e)).toList();
          });
        });
        await TissueApi.updateTissue(Tissue(
            id: widget.tissueDetail.id,
            name: txtName.text,
            sortId: updatedTissue[0].sortId,
            regionId: updatedTissue[0].regionId,
            gender: txtGender.text));
        Navigator.pop(context, true);
        break;
      default:
    }
  }
}
