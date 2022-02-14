import 'package:flutter/material.dart';

import '../widgets/displaydropdownmenu.dart';

class KDropDownField extends StatefulWidget {
  final List<String> dropDownList;
  final String label;
  final double width;
  final double height;
  final String initialValue;
  bool isLabel = true;
  KDropDownField({Key? key, required this.dropDownList,
    required this.label,
    this.width = 100,
    this.height = 25,
    this.initialValue = "-----",}) : super(key: key){

    if(label == ""){
      isLabel = false;
    }
  }

  @override
  _KDropDownFieldState createState() => _KDropDownFieldState();
}

class _KDropDownFieldState extends State<KDropDownField> {
  late GlobalKey actionKey;
  late double xPosition, yPosition;
  late OverlayEntry floatingDropdown;
  late final FocusNode _focusNode;
  late String dropdownValue;
  bool showdropdownflag = true;
  bool isDropdownOpened = false;

  @override
  void initState() {
    dropdownValue = widget.initialValue;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
    actionKey = LabeledGlobalKey(dropdownValue);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.dispose();
  }

  void findDropdownBox(){
    RenderBox renderbox = actionKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderbox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown(){
    return OverlayEntry(builder: (context){
      return Positioned(
        left: xPosition,
        top: yPosition + widget.height,
        width: widget.width + widget.height,
        height: widget.height * 4,
        child: DisplayDropdownMenu(dropDownList: widget.dropDownList, setSelection: updateDropdownText,),
        /*Material(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(242,243,247,1),
              border:  Border(
                left:  BorderSide(color: Colors.transparent),
                top:  BorderSide(color: Colors.grey),
                right:  BorderSide(color: Colors.grey),
                bottom:  BorderSide(color: Colors.grey),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: widget.dropDownList.map((item) =>
                    InkWell(
                      hoverColor: Colors.grey,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5,3,5,7),
                        width: widget.width + widget.height,
                        height: widget.height,
                        decoration: const BoxDecoration(
                          border:  Border(
                            left:  BorderSide(color: Colors.grey),
                            top:  BorderSide(color: Colors.transparent),
                            right:  BorderSide(color: Colors.grey),
                            bottom:  BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Text(
                            item,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ).toList(),
              ),
            ),
          ),
        ),*/
      );
    });
  }

  void showDropdownList(){
    setState(() {
      showdropdownflag = !showdropdownflag;
      isDropdownOpened = false;
      floatingDropdown.remove();
    });
  }

  void updateDropdownText(String selectedValue){
    if(selectedValue != "NoValue"){
      dropdownValue = selectedValue;
    }
    print(selectedValue);
    showDropdownList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isLabel? Text(
          widget.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ) : const SizedBox(width: 0,),
        InkWell(
          key: actionKey,
          onTap: (){
            setState(() {
              if(isDropdownOpened){
                floatingDropdown.remove();
              }
              else{
                findDropdownBox();
                floatingDropdown = _createFloatingDropdown();
                Overlay.of(context)!.insert(floatingDropdown);
              }

              isDropdownOpened = !isDropdownOpened;
            });
          },
          focusNode: _focusNode,
          onFocusChange: (hasChanged){
            print(hasChanged);
            if(!hasChanged){
              updateDropdownText("NoValue");
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: widget.width + widget.height,
              height: widget.height,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      dropdownValue,
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Container(
                    width: widget.height,
                    height: widget.height,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey),
                        top:  BorderSide(color: Colors.transparent),
                        right:  BorderSide(color: Colors.transparent),
                        bottom:  BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: const Icon(
                        Icons.keyboard_arrow_down,
                      size: 23,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );



    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       widget.label,
    //       style: const TextStyle(
    //         fontSize: 11,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   Container(
    //       width: widget.width,
    //       height: widget.height * 1.8,
    //       padding: EdgeInsets.zero,
    //       // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    //       child: DropdownButton(
    //         elevation: 0,
    //           value: dropdownValue,
    //           icon: const Icon(Icons.keyboard_arrow_down),
    //           items: widget.dropDownList.map<DropdownMenuItem<String>>((String item){
    //             return DropdownMenuItem(
    //                 value: item,
    //                 child: Text(item),
    //             );
    //           },
    //           ).toList(),
    //           onChanged: (String value){
    //             setState(() {
    //               dropdownValue = value;
    //             });
    //           },
    //       ),
    //     ),
    //   ],
    // );
  }
}
