import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KDateTextForm extends StatefulWidget {
  final String label;
  late Function? selectedDate;
  KDateTextForm({
    Key? key,
    required this.label,
    this.selectedDate,
  }) : super(key: key);

  @override
  State<KDateTextForm> createState() => _KDateTextFormState();
}

class _KDateTextFormState extends State<KDateTextForm> {
  late final dateinput;
  @override
  void initState() {
    dateinput = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: TextFormField(
        controller: dateinput,
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: widget.label, //label text of field
        ),
        onTap: selectDate,
      ),
    );
  }

  void selectDate() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
          2000), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );
    // _pickedDate = DateFormat("d-M-y").parse(_pickedDate.toString());

    if (_pickedDate != null) {
      print(_pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String _formattedDate = DateFormat('d-M-y').format(_pickedDate);
      print(
          _formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        dateinput.text = _formattedDate; //set output date to TextField value.
        widget.selectedDate!(DateFormat("d-M-y").parse(dateinput.text));
      });
    } else {
      print("Date is not selected");
    }
  }
}
