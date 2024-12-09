const String baseUrl = "https://www.goasbar.com";

String madaRegexV =
    "4(0(0861|1757|7(197|395)|9201)|1(0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)";
String madaRegexM =
    "5(0(4300|8160)|13213|2(1076|4(130|514)|9(415|741))|3(0906|1095|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1))";

var cities = [
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

var citiesMap = {
  "Riyadh": "RIYADH",
  "Mecca": "MECCA",
  "Medina": "MEDINA",
  "Tabuk": "TABUK",
  "Najran": "NAJRAN",
  "Al Qassim": "AL_QASSIM",
  "Eastern Province": "EASTERN_PROVINCE",
  "Aseer": "ASEER",
  "Hail": "HAIL",
  "Northern Borders Province": "NORTHERN_BORDERS_PROVINCE",
  "Jazan": "JAZAN",
  "Al Bahah": "AL_BAHAH",
  "Al Jowf": "AL_JOWF",
  "الرياض": "RIYADH",
  "مكة المكرمة": "MECCA",
  "المدينة المنورة": "MEDINA",
  "تبوك": "TABUK",
  "نجران": "NAJRAN",
  "القصيم": "AL_QASSIM",
  "المنطقة الشرقية": "EASTERN_PROVINCE",
  "عسير": "ASEER",
  "حائل": "HAIL",
  "منطقة الحدود الشمالية": "NORTHERN_BORDERS_PROVINCE",
  "جازان": "JAZAN",
  "الباحة": "AL_BAHAH",
  "الجوف": "AL_JOWF",
};

var genderMap = {
  "Male": "M",
  "Female": "F",
  "ذكر": "M",
  "أنثى": "F",
};

var categories = [
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

final List<String> shortMonthsArabic = <String>[
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

final List<String> weekDays = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

final genderConstraints = [
  "None",
  "FAMILIES",
  "MEN",
  "WOMEN",
];
