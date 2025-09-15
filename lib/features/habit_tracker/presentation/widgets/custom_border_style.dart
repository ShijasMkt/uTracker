import 'package:flutter/material.dart';
import 'package:utracker/core/constrants/app_colors.dart';

OutlineInputBorder customBorderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.mainGreyColor),
    );
  }