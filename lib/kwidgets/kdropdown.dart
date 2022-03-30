import 'package:erpapp/utils/default_fieldvalidator.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:form_field_validator/form_field_validator.dart';

class KDropdown extends StatelessWidget {
  final List<String> dropDownList;
  final String label;
  final double width;
  final double height;
  String initialValue;
  final Function? onChangeDropDown;
  final FieldValidator? validator;
  String selectedValue = "";
  bool isShowSearchBox;
  double maxHeight;
  bool isMandatory;
  KDropdown({
    Key? key,
    required this.dropDownList,
    required this.label,
    this.width = 100,
    this.height = 25,
    this.initialValue = "-----",
    this.onChangeDropDown,
    this.isShowSearchBox = true,
    this.maxHeight = 200,
    this.validator,
    this.isMandatory = false,
  }) : super(key: key);

  String getSelectedValue() {
    return selectedValue;
  }


  @override
  Widget build(BuildContext context) {
    print("kdropdown widget build called");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            isMandatory ? Text(
              " *",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ) : Container(),
          ],
        ),
        Container(
          width: width + height,
          // height: height * 2,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          child: DropdownSearch(
            dialogMaxWidth: width + height,
            maxHeight: maxHeight,
            showSearchBox: isShowSearchBox,
            selectedItem: initialValue,
            validator: validator ?? DefaultFieldValidator(),
            // validator: (value) => value == "-----"? "$label Required" : null,
            popupBackgroundColor: const Color.fromRGBO(242, 243, 247, 1),
            popupElevation: 0,
            onChanged: (value) => onChangeDropDown!(value.toString()),
            popupShape: const Border(
              left: BorderSide(color: Colors.grey),
              top: BorderSide(color: Colors.grey),
              right: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
            dropdownSearchBaseStyle: const TextStyle(fontSize: 2),
            mode: Mode.MENU,
            items: dropDownList,
            dropdownSearchDecoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
