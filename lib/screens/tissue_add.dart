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

class TissueAddState extends State<TissueAdd> {
  List<Region> regions;
  List<Sort> sorts;
  List<String> genders = ["Male", "Female", ""];
  var dropdownRegionValue = "1";
  var dropdownSortValue = "1";
  var dropdownGenderValue;
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
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownRegionValue,
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
          dropdownRegionValue = newValue;
          txtRegion.text = newValue;
        });
      },
      items: regions
          .map((r) => r.id.toString())
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
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownSortValue,
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
          dropdownSortValue = newValue;
          txtSort.text = newValue;
        });
      },
      items: sorts
          .map((s) => s.id.toString())
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

  buildGenderField() {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownGenderValue,
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
          dropdownGenderValue = newValue;
          txtGender.text = newValue;
        });
      },
      items: genders
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(value,
              ),
            ));
      }).toList(),
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
        gender: txtGender.text == "" ? null:txtGender.text);
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
