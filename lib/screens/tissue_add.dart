import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_app/data/dbHelper.dart';
import 'package:sqflite_app/models/Tissue.dart';

class TissueAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TissueAddState();
  }
}

class TissueAddState extends State {
  var dbHelper = DbHelper();
  var txtName = TextEditingController();
  var txtSort = TextEditingController();
  var txtRegion = TextEditingController();
  var txtGender = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tissue Add"),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            buildNameField(),
            buildSortField(),
            buildRegionField(),
            buildGenderField(),
            buildSaveButton()
          ],
        ),
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

  buildSaveButton() {
    return TextButton(
      child: Text("Add"),
      onPressed: () {
        addTissue();
      },
    );
  }

  void addTissue() async {
    await dbHelper.insert(Tissue(
        name: txtName.text,
        sort: txtSort.text,
        gender: txtGender.text,
        region: txtRegion.text));
    Navigator.pop(context, true);
  }
}
