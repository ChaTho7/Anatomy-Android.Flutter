import 'dart:convert';
import 'package:ChaTho_Anatomy/data/api/region_api.dart';
import 'package:ChaTho_Anatomy/data/api/sort_api.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/models/Region.dart';
import 'package:ChaTho_Anatomy/models/Sort.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TissueAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TissueAddState();
  }
}

class TissueAddState extends State {
  List<Region> regions;
  List<Sort> sorts;
  var txtName = TextEditingController();
  var txtSort = TextEditingController();
  var txtRegion = TextEditingController();
  var txtGender = TextEditingController();

  @override
  void initState() {
    getRegions();
    getSorts();
    super.initState();
  }

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

  buildRegionField() {
    var dropdownValue = "1";
    txtRegion.text = "1";
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          txtRegion.text = newValue;
          print(txtRegion.text);
        });
      },
      items: regions
          .map((e) => e.id.toString())
          .toList()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(
                regions.firstWhere((r) => r.id == int.parse(value)).name,
              ),
            ));
      }).toList(),
    );
  }

  buildSortField() {
    var dropdownValue = "1";
    txtSort.text = "1";
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          txtSort.text = newValue;
          print(txtSort.text);
        });
      },
      items: sorts
          .map((e) => e.id.toString())
          .toList()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(
                sorts.firstWhere((r) => r.id == int.parse(value)).name,
              ),
            ));
      }).toList(),
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
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black54)),
      child: Text(
        "Add",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        addTissue();
      },
    );
  }

  void addTissue() async {
    var addedTissue = new Tissue(
        name: txtName.text,
        regionId: int.parse(txtRegion.text),
        sortId: int.parse(txtSort.text),
        gender: txtGender.text);
    await TissueApi.addTissue(addedTissue);
    Navigator.pop(context, true);
  }

  void getRegions() {
    RegionApi.getRegions().then((response) => {
          setState(() {
            var jsonMap = json.decode(response.body);
            ResponseModel responseModel = new ResponseModel.fromJson(jsonMap);
            var list = responseModel.data;
            regions = list.map((e) => Region.fromJson(e)).toList();
          })
        });
  }

  void getSorts() {
    SortApi.getSorts().then((response) => {
          setState(() {
            var jsonMap = json.decode(response.body);
            ResponseModel responseModel = new ResponseModel.fromJson(jsonMap);
            var list = responseModel.data;
            sorts = list.map((e) => Sort.fromJson(e)).toList();
          })
        });
  }
}
