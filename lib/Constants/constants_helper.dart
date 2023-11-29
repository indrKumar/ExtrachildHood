import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:flutter/material.dart';

class ConstantsHelper{
  static Widget loadingIndicator(){
    return  Center(
        child: CircularProgressIndicator(
            color: Colors.deepOrangeAccent,
        )
    );
}
}