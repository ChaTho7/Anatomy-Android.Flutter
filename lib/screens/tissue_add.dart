import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TissueAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TissueAddState();
  }
}

class TissueAddState extends State {
  var txtName = TextEditingController();
  var txtSort = TextEditingController();
  var txtRegion = TextEditingController();
  var txtGender = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
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
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black54)),
      child: Text("Add",style: TextStyle(color: Colors.white),),
      onPressed: () {
        addTissue();
      },
    );
  }

  void addTissue() async {
    /*await dbHelper.insert(Tissue(
        name: txtName.text,
        sort: txtSort.text,
        gender: txtGender.text,
        region: txtRegion.text));*/
    Navigator.pop(context, true);
  }
}
