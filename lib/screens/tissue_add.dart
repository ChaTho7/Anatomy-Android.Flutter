import 'dart:async';
import 'dart:convert';
import 'package:ChaTho_Anatomy/data/api/region_api.dart';
import 'package:ChaTho_Anatomy/data/api/sort_api.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/models/ListResponseModel.dart';
import 'package:ChaTho_Anatomy/models/Region.dart';
import 'package:ChaTho_Anatomy/models/Sort.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/utilities/ReloadPage.dart';
import 'package:ChaTho_Anatomy/widgets/LoadingPage.dart';
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
  var dropdownRegionValue;
  var dropdownSortValue;
  var dropdownGenderValue;
  var txtName = TextEditingController();
  Map<String,bool> results={"regions":false,"sorts":false};
  Function reloader;

  @override
  void initState() {
    reloader = ()=>ReloadPage.reloadPage(context, TissueAdd());
    getRegions();
    getSorts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (results.values.contains(false) ? false:true) {
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
              SizedBox(
                height: 25,
              ),
              buildSaveButton()
            ],
          ),
        ),
      );
    } else {
      return LoadingPage(reloader, results);
    }
  }

  TextField buildNameField() {
    return TextField(
      cursorColor: Colors.black,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          contentPadding: new EdgeInsets.symmetric(vertical: 10),
          labelText: "Tissue Name",
          alignLabelWithHint: true,
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

  buildRegionField() {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownRegionValue,
      icon: const Icon(Icons.arrow_downward),
      iconEnabledColor: Colors.black,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownRegionValue = newValue;
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
      iconEnabledColor: Colors.black,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownSortValue = newValue;
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
      iconEnabledColor: Colors.black,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownGenderValue = newValue;
        });
      },
      items: genders.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(
                value,
              ),
            ));
      }).toList(),
    );
  }

  buildSaveButton() {
    return SizedBox(
      width: 100,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black87)),
        child: Text(
          "Add",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          addTissue();
        },
      ),
    );
  }

  Future addTissue() async {
    var addedTissue = new Tissue(
        name: txtName.text,
        regionId: int.parse(dropdownRegionValue),
        sortId: int.parse(dropdownSortValue),
        gender: dropdownGenderValue == "" ? null : dropdownGenderValue);
    await TissueApi.addTissue(addedTissue);
    Navigator.pop(context, true);
  }

  Future getRegions() async {
    await RegionApi.getRegions().then((response) => {
          setState(() {
            var jsonMap = json.decode(response.body);
            ListResponseModel listResponseModel =
                new ListResponseModel.fromJson(jsonMap);
            var list = listResponseModel.dataList;
            regions = list.map((e) => Region.fromJson(e)).toList();
            setState(() {
              results["regions"]=true;
            });
          })
        });
  }

  Future getSorts() async {
    await SortApi.getSorts().then((response) => {
          setState(() {
            var jsonMap = json.decode(response.body);
            ListResponseModel listResponseModel =
                new ListResponseModel.fromJson(jsonMap);
            var list = listResponseModel.dataList;
            sorts = list.map((e) => Sort.fromJson(e)).toList();
            setState(() {
              results["sorts"]=true;
            });
          })
        });
  }
}
