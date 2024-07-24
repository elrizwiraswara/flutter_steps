import 'package:flutter/material.dart';

class Steps {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final bool isActive;

  Steps({
    this.title,
    this.subtitle,
    this.leading,
    this.isActive = false,
  });
}
