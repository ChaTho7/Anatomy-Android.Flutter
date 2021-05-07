import 'package:flutter/material.dart';

class ReloadPage {
  static reloadPage(BuildContext _context, var instance) {
    Navigator.push(_context, MaterialPageRoute(builder: (context) => instance));
  }
}
