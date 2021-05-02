import 'dart:async';
import 'dart:convert';
import 'package:ChaTho_Anatomy/data/api/region_api.dart';
import 'package:ChaTho_Anatomy/data/api/sort_api.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/models/ListResponseModel.dart';
import 'package:ChaTho_Anatomy/models/Region.dart';
import 'package:ChaTho_Anatomy/models/Sort.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TissueAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TissueAddState();
  }
}

class TissueAddState extends State<TissueAdd> {
  TissueAddState() {
    startTimer();
  }

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
  bool regionResult = false;
  bool sortResult = false;
  Timer _timer;
  int timer = 10;

  @override
  void initState() {
    getRegions().whenComplete(() => setState(() {
          regionResult = true;
        }));
    getSorts().whenComplete(() => setState(() {
          sortResult = true;
        }));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sortResult && regionResult) {
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
      return buildLoadingPage();
    }
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (result) {
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
        child: Text("Try again", style: TextStyle(fontFamily: 'BebasNeue')),
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // background
          onPrimary: Colors.black, // foreground
        ));
  }

  reloadPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TissueAdd()));
  }

  buildLoadingPage(){
    return Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Text(
                "ChaTho Anatomy",
                style: TextStyle(fontSize: 50, fontFamily: 'BebasNeue'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
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
                child: Text("Getting data" + "." * timer,
                    style: TextStyle(fontFamily: 'BebasNeue')),
              ),
            ],
          ),
        ));
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
        regionId: int.parse(txtRegion.text),
        sortId: int.parse(txtSort.text),
        gender: txtGender.text == "" ? null : txtGender.text);
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
          })
        });
  }
}
