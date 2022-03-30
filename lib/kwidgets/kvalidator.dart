library form_field_validator;

import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../model/challan.dart';
import '../providers/challan_provider.dart';

class KZeroValidator extends TextFieldValidator {
  final String errorText;
  KZeroValidator({required this.errorText}) : super(errorText);

  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  @override
  bool isValid(String? value) {
    return currencyFormat.parse(value!) != 0 ? true : false;
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }
}

class KDropDownFieldValidator extends FieldValidator<String?> {
  final String errorText;

  KDropDownFieldValidator({required this.errorText}) : super(errorText);

  @override
  bool isValid(value) {
    return value.toString() != "-----" ? true : false;
  }

  @override
  String? call(value) {
    return isValid(value) ? null : errorText;
  }
}

class KDropDownFieldCheckReduncencyValidator extends FieldValidator<String?> {
  final String errorText;
  final int index;
  final Function? checkRedundency;

  KDropDownFieldCheckReduncencyValidator({
    required this.errorText,
    required this.index,
    this.checkRedundency,
  }) : super(errorText);

  @override
  bool isValid(value) {
    print(
        "Check Redundency in KValidator: ${value} Status: ${checkRedundency!(value, index)}");

    return checkRedundency!(value, index) ? true : false;
  }

  @override
  String? call(value) {
    return isValid(value) ? errorText : null;
  }
}

class KCheckChallanNumberValidator extends FieldValidator<String?> {
  final String errorText;
  final List<Challan> challanList;
  final bool isEdit;
  bool status = true;

  KCheckChallanNumberValidator({
    required this.errorText,
    required this.challanList,
    required this.isEdit,
  }) : super(errorText);

  @override
  bool isValid(value) {
    status = challanList.any((element) => element.challanNo == value);
    print("KCheckChallanNumberValidator. Value: $value, Status: $status");

    return isEdit
        ? true
        : !status
            ? true
            : false;
  }

  @override
  String? call(value) {
    return isValid(value) ? null : errorText;
  }
}
