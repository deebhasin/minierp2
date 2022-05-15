import 'package:pdf/widgets.dart';

class KPdfContainerTextWiget extends Container {
  String label;
  KPdfContainerTextWiget({
    required this.label,
}){

    Container(
      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
      width: 78,
      height: 30,
      decoration: BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(), horizontal: BorderSide.none)),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
