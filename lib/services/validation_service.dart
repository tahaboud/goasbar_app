import 'package:easy_localization/easy_localization.dart';
import 'package:string_validator/string_validator.dart';

class ValidationService {
  String? validateFirstName(String? value) {
    if (value!.isEmpty) {
      return tr("First name cannot be empty.");
    } else if (value.length < 2) {
      return tr("First name must be more than 2 characters long.");
    } else {
      return null;
    }
  }

  String? validateLastName(String? value) {
    if (value!.isEmpty) {
      return tr("Last name cannot be empty.");
    } else if (value.length < 2) {
      return tr("Last name must be more than 2 characters long.");
    } else {
      return null;
    }
  }

  String? passwordValidation(String? value) {
    if (value!.isEmpty) {
      return tr("Password cannot be empty.");
    } else if (value.length < 8) {
      return tr("Password must be more than 8 characters long.");
    } else {
      return null;
    }
  }

  String? rePasswordValidation({String? password, String? rePassword}) {
    if (rePassword!.isEmpty) {
      return tr("Password cannot be empty.");
    } else if (password != rePassword) {
      return tr("Password does not match.");
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return tr("Phone number cannot be empty.");
    } else {
      const pattern = r'^[5][0-9]{8}$';
      final regExp = RegExp(pattern);

      if (regExp.hasMatch(value)) {
        return null;
      } else {
        return tr("Invalid phone number.");
      }
    }
  }

  String? validateIsNumeric(String? value) {
    if (isNumeric(value!)) {
      return null;
    } else {
      return "Age must be in numbers only";
    }
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return tr("Email cannot be empty.");
    } else {
      const pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
      final regExp = RegExp(pattern);

      if (regExp.hasMatch(value)) {
        return null;
      } else {
        return tr("Invalid email.");
      }
    }
  }
}
