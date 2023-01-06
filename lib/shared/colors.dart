import 'dart:ui';
import 'package:flutter/cupertino.dart';

const Color kMainColor1 = Color(0xff3AB5AF);
const Color kMainColor2 = Color(0xff4272AF);
const Color kMainGray = Color(0xff89807A);
const Color kMainDisabledGray = Color(0xffDDDDDD);
const Color kTextFiledMainColor = Color(0xfff3f7FB);
const Color kTextFiledGrayColor = Color(0xffF0F0F0);
const Color kStarColor = Color(0xffFFDD00);
const Color kGrayText = Color(0xff9FA0B4);
const Color kAgencyColor = Color(0xffECF7FE);

const kMainGradient = LinearGradient(
  colors: [
    kMainColor1,
    kMainColor2,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kMainDisabledGradient = LinearGradient(
  colors: [
    kMainDisabledGray,
    kMainDisabledGray,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kDisabledGradient = LinearGradient(
  colors: [
    kTextFiledGrayColor,
    kTextFiledGrayColor,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);