import 'dart:convert';

import 'package:ChaTho_Anatomy/data/api/region_api.dart';
import 'package:ChaTho_Anatomy/data/api/sort_api.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/models/Region.dart';
import 'package:ChaTho_Anatomy/models/Sort.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/Tissue_Details.dart';
import 'package:ChaTho_Anatomy/models/response_model.dart';
import 'package:flutter/material.dart';

class TissueDetail extends StatefulWidget {
  TissueDetail(this.tissueDetail,this.updatedTissue);

  TissueDetails tissueDetail;
  List<Tissue> updatedTissue;

  @override
  State<StatefulWidget> createState() {
    return _TissueDetailState();
  }


}

enum Options { delete, update }

class _TissueDetailState extends State<TissueDetail> {
  //_TissueDetailState();

  List<Region> regions;
  List<Sort> sorts;
  List<String> genders = ["Male", "Female", ""];
  List<String> origins = ["Endoderm", "Ektoderm", "Mezoderm"];
  var dropdownGenderValue;
  var dropdownOriginValue;
  var dropdownRegionValue;
  var dropdownSortValue;
  var txtName = TextEditingController();
  var txtSort = TextEditingController();
  var txtRegion = TextEditingController();
  var txtGender = TextEditingController();
  var txtOrigin = TextEditingController();

  @override
  void initState() {
    getRegions();
    getSorts();
    setValues();
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
          buildGenderField(),
          buildOriginField()
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

  buildOriginField() {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownOriginValue,
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
          dropdownOriginValue = newValue;
          txtGender.text = newValue;
        });
      },
      items: origins.map<DropdownMenuItem<String>>((String value) {
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

  void setValues() {
    dropdownRegionValue = widget.updatedTissue[0].regionId.toString();
    dropdownSortValue = widget.updatedTissue[0].sortId.toString();
    dropdownGenderValue = widget.updatedTissue[0].gender;
    dropdownOriginValue = widget.tissueDetail.origin;
    txtName.text = widget.tissueDetail.name;
    txtRegion.text = widget.updatedTissue[0].regionId.toString();
    txtSort.text = widget.updatedTissue[0].sortId.toString();
    txtGender.text = widget.tissueDetail.gender;
    txtOrigin.text = widget.tissueDetail.origin;
  }

  void selectProcess(Options value) async {
    switch (value) {
      case Options.delete:
        //await dbHelper.delete(tissue.id);
        Navigator.pop(context, true);
        break;
      case Options.update:
        print(txtSort.text);
        print(txtRegion.text);
        await TissueApi.updateTissue(Tissue(
            id: widget.tissueDetail.id,
            name: txtName.text,
            sortId: int.parse(txtSort.text),
            regionId: int.parse(txtRegion.text),
            gender: txtGender.text));
        Navigator.pop(context, true);
        break;
      default:
    }
  }
}
