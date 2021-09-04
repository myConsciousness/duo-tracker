import 'package:duovoc_flutter/main.dart';
import 'package:flutter/material.dart';
import 'flavors.dart';

void main() {
  F.appFlavor = Flavor.PAID;
  runApp(Duovoc());
}
