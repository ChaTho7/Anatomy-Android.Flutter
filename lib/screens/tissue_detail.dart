import 'dart:async';
import 'dart:convert';

import 'package:ChaTho_Anatomy/data/api/region_api.dart';
import 'package:ChaTho_Anatomy/data/api/sort_api.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/models/ListResponseModel.dart';
import 'package:ChaTho_Anatomy/models/Region.dart';
import 'package:ChaTho_Anatomy/models/Sort.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/Tissue_Details.dart';
import 'package:ChaTho_Anatomy/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TissueDetail extends StatefulWidget {
  TissueDetails tissueDetail;

  TissueDetail(this.tissueDetail);

  @override
  State<StatefulWidget> createState() {
    return _TissueDetailState();
  }
}

enum Options { delete, update }

class _ReloadPage extends State<TissueDetail> {
  Tissue selectedTissue;

  _ReloadPage(this.selectedTissue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          SpinKitFoldingCube(
            color: Colors.black,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {
              reloadPage();
            },
            child: Text("Reload"),
          )
        ],
      ),
    ));
  }

  reloadPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TissueDetail(widget.tissueDetail)));
  }
}

class _TissueDetailState extends State<TissueDetail> {
  _TissueDetailState() {
    startTimer();
  }

  Tissue selectedTissue;
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
  bool regionResult = false;
  bool sortResult = false;
  bool tissueResult = false;
  int timer = 5;

  @override
  void initState() {
    getTissueById(widget.tissueDetail.id).whenComplete(() => setState(() {
          tissueResult = true;
        }));
    getRegions().whenComplete(() => setState(() {
          regionResult = true;
        }));
    getSorts().whenComplete(() => setState(() {
          sortResult = true;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (sortResult && regionResult && tissueResult) {
      setValues();
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
    } else {
      return Scaffold(
          body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            SpinKitFoldingCube(
              color: Colors.black,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            timer == 0
                ? buildTryButton()
                : SizedBox(
                    child: Text("Getting data... " + timer.toString()),
                  ),
          ],
        ),
      ));
    }
  }

  startTimer() {
    Timer.periodic(Duration(seconds: 1), (result) {
      setState(() {
        timer--;
        if (timer == 0) {
          result.cancel();
        }
      });
    });
  }

  buildTryButton() {
    return ElevatedButton(
        onPressed: reloadPage,
        child: Text("Try again"),
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // background
          onPrimary: Colors.black, // foreground
        ));
  }

  Future getTissueById(int id) async {
    await TissueApi.getTissueById(id).then((response) {
      var jsonMap = json.decode(response.body);
      ResponseModel<Tissue> responseModel =
          new ResponseModel(data: new Tissue.fromJson(jsonMap['data']));
      setState(() {
        selectedTissue = responseModel.data;
      });
    });
  }

  reloadPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TissueDetail(widget.tissueDetail)));
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
      cursorColor: Colors.black,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          contentPadding: new EdgeInsets.symmetric(vertical: 10),
          labelText: "Tissue Name",
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

  Future getRegions() async {
    await RegionApi.getRegions().then((response) => {
          setState(() {
            var jsonMap = json.decode(response.body);
            ListResponseModel listResponseModel =
                new ListResponseModel.fromJson(jsonMap);
            var list = listResponseModel.dataList;
            regions = list.map((e) => Region.fromJson(e)).toList();
          })
        });
  }

  Future getSorts() async {
    SortApi.getSorts().then((response) => {
          setState(() {
            var jsonMap = json.decode(response.body);
            ListResponseModel listResponseModel =
                new ListResponseModel.fromJson(jsonMap);
            var list = listResponseModel.dataList;
            sorts = list.map((e) => Sort.fromJson(e)).toList();
          })
        });
  }

  void setValues() {
    dropdownRegionValue = selectedTissue.regionId.toString();
    dropdownSortValue = selectedTissue.sortId.toString();
    dropdownGenderValue = selectedTissue.gender;
    dropdownOriginValue = widget.tissueDetail.origin;
    txtName.text = widget.tissueDetail.name;
    txtRegion.text = selectedTissue.regionId.toString();
    txtSort.text = selectedTissue.sortId.toString();
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
