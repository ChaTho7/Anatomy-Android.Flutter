import 'package:flutter/material.dart';
import 'package:ChaTho_Anatomy/screens/tissue_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TissueList(),
    );
  }

}