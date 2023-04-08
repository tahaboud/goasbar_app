import 'package:easy_localization/easy_localization.dart';
import 'package:string_validator/string_validator.dart';

class ValidationService {
  String? passwordValidation(String? value) {
    if (value!.isEmpty) {
      return tr("Empty field");
    } else if (value.length < 4) {
      return tr("Must be more than 4 letters");
    } else {
      return null;
    }
  }

  String? rePasswordValidation({String? password, String? rePassword}) {
    if (rePassword!.isEmpty) {
      return tr("Empty field");
    } else if (rePassword.length < 4) {
      return tr("Must be more than 4 letters");
    } else if (password != rePassword) {
      return tr("Password does not match");
    } else{
      return null;
    }
  }

  String? validatePhoneNumber (String? value) {
    if (value!.isEmpty) {
      return tr("Empty field");
    } else {
      const pattern = r'^[5][0-9]{8}$';
      final regExp = RegExp(pattern);

      if (regExp.hasMatch(value)) {
        return null;
      } else {
        return "Wrong phone number";
      }
    }
  }

  String? validateEmail (String? value) {
    if (value!.isEmpty) {
      return tr("Empty field");
    } else {
      const pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
      final regExp = RegExp(pattern);

      if (regExp.hasMatch(value)) {
        return null;
      } else {
        return "Wrong Email";
      }
    }
  }
}
