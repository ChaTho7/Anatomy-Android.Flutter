import 'package:flutter/material.dart';
import 'package:sqflite_app/data/dbHelper.dart';
import 'package:sqflite_app/models/Tissue.dart';
import 'package:sqflite_app/screens/tissue_add.dart';
import 'package:sqflite_app/screens/tissue_detail.dart';

class TissueList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TissueListState();
  }
}

class _TissueListState extends State {
  DbHelper dbHelper = DbHelper();
  List<Tissue> tissues;
  int tissueCount = 0;

  @override
  void initState() {
    getTissues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tissue List"),
      ),
      body: buildTissueList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToTissueAdd();
        },
        child: Icon(Icons.add),
        tooltip: "Add new tissue",
      ),
    );
  }

  ListView buildTissueList() {
    return ListView.builder(
      itemCount: tissueCount,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.blueGrey,
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black38,
              child: Text("a"),
            ),
            title: Text(this.tissues[position].name),
            subtitle: Text(this.tissues[position].sort),
            onTap: () {
              goToDetail(this.tissues[position]);
            },
          ),
        );
      },
    );
  }

  void goToTissueAdd() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TissueAdd()));
    if (result != null) {
      if (result) {
        getTissues();
      }
    }
  }

  void getTissues() async {
    var tissuesFuture = dbHelper.getTissues();
    tissuesFuture.then((data) {
      setState(() {
        this.tissues = data;
        tissueCount = data.length;
      });
    });
  }

  void goToDetail(Tissue tissue) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TissueDetail(tissue)));
    if (result != null) {
      if (result) {
        getTissues();
      }
    }
  }
}
