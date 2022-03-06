import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';


class KDropdown extends StatefulWidget {
  final List<String> dropDownList;
  final String label;
  final double width;
  final double height;
  final String initialValue;
  final Function? onChangeDropDown;
  String selectedValue = "";
  KDropdown({Key? key,
    required this.dropDownList,
    required this.label,
    this.width = 100,
    this.height = 25,
    this.initialValue = "-----",
    this.onChangeDropDown,
  }) : super(key: key);

  String getSelectedValue(){
    return selectedValue;
  }

  @override
  _KDropdownState createState() => _KDropdownState();
}

class _KDropdownState extends State<KDropdown> {
  String dropdownValue = "-----";

  void updateDropdownText(String selectedValue){
    if(selectedValue != "NoValue"){
      widget.selectedValue = selectedValue;
    }
    print("Selection: $dropdownValue");
    // showDropdownList();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: widget.width + widget.height,
          height: widget.height * 2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10,0,0,0),
            child: DropdownSearch(
              dialogMaxWidth: widget.width + widget.height,
              showSearchBox: true,
              selectedItem: widget.initialValue,
              popupBackgroundColor: const Color.fromRGBO(242,243,247,1),
              popupElevation: 0,
              onChanged: (value) => updateDropdownText(value.toString()),
              popupShape: const Border(
                left:  BorderSide(color: Colors.grey),
                top:  BorderSide(color: Colors.grey),
                right:  BorderSide(color: Colors.grey),
                bottom:  BorderSide(color: Colors.grey),
              ),
              dropdownSearchBaseStyle: const TextStyle(fontSize: 2),
              mode: Mode.MENU,
              items: widget.dropDownList,
              dropdownSearchDecoration: const InputDecoration(
                border: InputBorder.none,
                // icon: Icon(
                //     Icons.keyboard_arrow_down,
                //   size: 23,
                // ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
