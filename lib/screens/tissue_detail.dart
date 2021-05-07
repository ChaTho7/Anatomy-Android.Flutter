import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ChaTho_Anatomy/data/api/region_api.dart';
import 'package:ChaTho_Anatomy/data/api/sort_api.dart';
import 'package:ChaTho_Anatomy/data/api/tissueImage_api.dart';
import 'package:ChaTho_Anatomy/data/api/tissue_api.dart';
import 'package:ChaTho_Anatomy/models/ListResponseModel.dart';
import 'package:ChaTho_Anatomy/models/Region.dart';
import 'package:ChaTho_Anatomy/models/Sort.dart';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:ChaTho_Anatomy/models/TissueImage.dart';
import 'package:ChaTho_Anatomy/models/Tissue_Details.dart';
import 'package:ChaTho_Anatomy/models/response_model.dart';
import 'package:ChaTho_Anatomy/screens/abstract/screen.dart';
import 'package:ChaTho_Anatomy/utilities/ReloadPage.dart';
import 'package:ChaTho_Anatomy/widgets/CarouselSlider.dart';
import 'package:ChaTho_Anatomy/widgets/LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class TissueDetail extends StatefulWidget {
  TissueDetails tissueDetail;

  TissueDetail(this.tissueDetail);

  @override
  State<StatefulWidget> createState() {
    return _TissueDetailState();
  }
}

enum Options { delete, update }

class _TissueDetailState extends State<TissueDetail> implements Screen {
  Tissue selectedTissue;
  List<Region> regions;
  List<Sort> sorts;
  List<TissueImage> tissueImages;
  List<String> genders = ["Male", "Female", ""];
  List<String> origins = ["Endoderm", "Ektoderm", "Mezoderm"];
  var dropdownGenderValue;
  var dropdownOriginValue;
  var dropdownRegionValue;
  var dropdownSortValue;
  var txtName = TextEditingController();
  Map<String, bool> results = {
    "regions": false,
    "sorts": false,
    "tissue": false,
    "tissueImages": false
  };
  File pickedImage;

  @override
  Function reloader;

  @override
  void initState() {
    reloader =
        () => ReloadPage.reloadPage(context, TissueDetail(widget.tissueDetail));
    getSorts();
    getRegions();
    getTissueById(widget.tissueDetail.id);
    getTissueImages(widget.tissueDetail.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (results.values.contains(false) ? false : true) {
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
                  height: 50,
                  value: Options.delete,
                  child: Center(
                      child: Text(
                    "Delete",
                    style: TextStyle(fontFamily: 'BebasNeue'),
                  )),
                ),
                PopupMenuItem<Options>(
                  height: 50,
                  value: Options.update,
                  child: Center(
                      child: Text("Update",
                          style: TextStyle(fontFamily: 'BebasNeue'))),
                )
              ],
            )
          ],
        ),
        body: buildTissueDetail(),
      );
    } else {
      return LoadingPage(reloader, results);
    }
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
          buildOriginField(),
          buildAddImageButton(),
          SizedBox(
            child: pickedImage == null ? SizedBox():IconButton(icon: Icon(Icons.send), onPressed: () {addTissueImages();}),
            height: 30,
          ),
          Carousel.buildTissueImageCarousel(context, tissueImages),
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

  buildAddImageButton() {
    return IconButton(
      icon: Icon(Icons.image_rounded),
      color: Colors.black,
      iconSize: 30,
      onPressed: getImageFromGallery,
    );
  }

  Future getImageFromGallery() async{
    final image = await  ImagePicker.platform.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      pickedImage = File(image.path);
    });
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
              results["regions"] = true;
            });
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
            setState(() {
              results["sorts"] = true;
            });
          })
        });
  }

  Future getTissueImages(int id) async {
    await TissueImageApi.getTissueImages(id).then((response) => {
          setState(() {
            var jsonMap = json.decode(response.body);
            ListResponseModel listResponseModel =
                new ListResponseModel.fromJson(jsonMap);
            var list = listResponseModel.dataList;
            tissueImages = list.map((e) => TissueImage.fromJson(e)).toList();
            setState(() {
              results["tissueImages"] = true;
            });
          })
        });
  }

  Future getTissueById(int id) async {
    await TissueApi.getTissueById(id).then((response) {
      var jsonMap = json.decode(response.body);
      ResponseModel<Tissue> responseModel =
          new ResponseModel(data: new Tissue.fromJson(jsonMap['data']));
      setState(() {
        selectedTissue = responseModel.data;
        results["tissue"] = true;
      });
    });
  }

  Future addTissueImages() async{
    await TissueImageApi.addTissueImages(pickedImage,selectedTissue.id).then((response) {
      if((response as http.Response).statusCode == 200){
        var jsonMap = json.decode(response.body);
        ResponseModel responseModel =
        new ResponseModel.fromJson(jsonMap);
      }else{
        print((response as http.Response).body);
      }
    });
  }

  void setValues() {
    dropdownRegionValue = selectedTissue.regionId.toString();
    dropdownSortValue = selectedTissue.sortId.toString();
    dropdownGenderValue = selectedTissue.gender;
    dropdownOriginValue = widget.tissueDetail.origin;
    txtName.text = widget.tissueDetail.name;
  }

  void selectProcess(Options value) async {
    switch (value) {
      case Options.delete:
        //Navigator.pop(context, true);
        break;
      case Options.update:
        await TissueApi.updateTissue(Tissue(
            id: widget.tissueDetail.id,
            name: txtName.text,
            sortId: int.parse(dropdownSortValue),
            regionId: int.parse(dropdownSortValue),
            gender: dropdownGenderValue));
        Navigator.pop(context, true);
        break;
      default:
    }
  }

}
