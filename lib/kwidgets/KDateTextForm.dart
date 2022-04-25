import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KDateTextForm extends StatelessWidget {
  final String label;
  final TextEditingController dateInputController;
  final Function? onDateChange;

  KDateTextForm({
    Key? key,
    required this.label,
    required this.dateInputController,
    this.onDateChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // late final _dateInputController = TextEditingController(
    //     text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

    return Container(
      width: 150,
      child: TextFormField(
        controller: dateInputController,
        readOnly: true,
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: label, //label text of field
        ),
        onTap: () => selectDate(context, onDateChange?? (){}),
      ),
    );
  }

  void selectDate(BuildContext context, Function onDateChange) async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd-MM-yyyy').parse(dateInputController.text),
      firstDate: DateTime(
          2000), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );

    if (_pickedDate != null) {
      print(_pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String _formattedDate = DateFormat('d-M-y').format(_pickedDate);
      print(
          _formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      dateInputController.text =
          _formattedDate; //set output date to TextField value.
      onDateChange();
    } else {
      print("Date is not selected");
    }
  }
}
