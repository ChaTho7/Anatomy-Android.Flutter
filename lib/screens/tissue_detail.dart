import 'package:flutter/material.dart';
import 'package:sqflite_app/data/dbHelper.dart';
import 'package:sqflite_app/models/Tissue.dart';

class TissueDetail extends StatefulWidget {
  TissueDetail(this.tissue);

  Tissue tissue;

  @override
  State<StatefulWidget> createState() {
    return _TissueDetailState(tissue);
  }
}

enum Options { delete, update }

class _TissueDetailState extends State {
  _TissueDetailState(this.tissue);

  Tissue tissue;
  var dbHelper = DbHelper();
  var txtName = TextEditingController();
  var txtSort = TextEditingController();
  var txtRegion = TextEditingController();
  var txtGender = TextEditingController();

  @override
  void initState() {
    txtName.text = tissue.name;
    txtRegion.text = tissue.region;
    txtSort.text = tissue.sort;
    txtGender.text = tissue.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tissue detail : ${tissue.name}"),
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

  void selectProcess(Options value) async {
    switch (value) {
      case Options.delete:
        await dbHelper.delete(tissue.id);
        Navigator.pop(context, true);
        break;
      case Options.update:
        await dbHelper.update(Tissue.withId(
            id: tissue.id,
            name: txtName.text,
            sort: txtSort.text,
            region: txtRegion.text,
            gender: txtGender.text));
        Navigator.pop(context, true);
        break;
      default:
    }
  }
}
