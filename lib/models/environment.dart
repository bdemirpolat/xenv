import 'package:flutter/material.dart';

class Environment {
  String key;
  String value;
  TextEditingController keyControlller;
  TextEditingController valueControlller;
  Environment(
    this.keyControlller,
    this.valueControlller, {
    this.key = "",
    this.value = "",
  });
}
