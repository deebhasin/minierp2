import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';


class KDropdown extends StatelessWidget {
  final List<String> dropDownList;
  final String label;
  final double width;
  final double height;
  String initialValue;
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

  void updateDropdownText(String selectedValue){
    if(selectedValue != "NoValue"){
      selectedValue = selectedValue;
      onChangeDropDown!("$selectedValue");
    }
    // print("Selection: $dropdownValue");
    // showDropdownList();
  }


  @override
  Widget build(BuildContext context) {

    print("kdropdown widget build called");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: width + height,
          height: height * 2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownSearch(
            dialogMaxWidth: width + height,
            showSearchBox: true,
            selectedItem: initialValue,
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
            items: dropDownList,
            dropdownSearchDecoration: const InputDecoration(
              border: InputBorder.none,
              // icon: Icon(
              //     Icons.keyboard_arrow_down,
              //   size: 23,
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
