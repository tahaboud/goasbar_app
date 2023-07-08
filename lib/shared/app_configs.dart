import 'package:easy_localization/easy_localization.dart';

const String baseUrl = "https://www.goasbar.com";

String madaRegexV = "4(0(0861|1757|7(197|395)|9201)|1(0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)";
String madaRegexM = "5(0(4300|8160)|13213|2(1076|4(130|514)|9(415|741))|3(0906|1095|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1))";

const cities = [
  "",
  "RIYADH",
  "MECCA",
  "MEDINA",
  "TABUK",
  "NAJRAN",
  "AL_QASSIM",
  "EASTERN_PROVINCE",
  "ASEER",
  "HAIL",
  "NORTHERN_BORDERS_PROVINCE",
  "JAZAN",
  "AL_BAHAH",
  "AL_JOWF",
];

const categories = [
  "LANDSCAPE",
  "HISTORY",
  "SPORT",
  "LIVE_STYLE",
  "FOOD",
  "ART",
  "FASHION",
  "OTHER",
];

final List<String> shortMonths = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

final List<String> weekDays = <String>[
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

final genderConstraints = [
  'No constrains'.tr(),
  'Families only'.tr(),
  'Men Only'.tr(),
  'Women Only'.tr(),
];