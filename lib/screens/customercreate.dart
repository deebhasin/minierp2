import 'package:erpapp/widgets/alertdialognav.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../kwidgets/ktextfield.dart';
import '../kwidgets/kvariables.dart';
import '../model/customer.dart';
import '../providers/customer_provider.dart';

class CustomerCreate extends StatefulWidget {
    late final Customer customer;

    CustomerCreate({Key? key,
      required this.customer
    }) : super(key: key);

  @override
  State<CustomerCreate> createState() => _CustomerCreateState();
}

class _CustomerCreateState extends State<CustomerCreate> {
  // late Customer customer;
  late double containerWidth;
  double containerHeight = 700;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController customerIdController ;
  late final companyController;
  late final contactPersonController;
  late final addressController ;
  late final pinController;
  late final cityController ;
  late final stateController;
  late final stateCodeController ;
  late final gstController ;
  late final creditPeriodController ;
  final companyNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Company Name is required'),
    MinLengthValidator(8, errorText: 'Company Name must be at least 8 digits long'),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);
  final pinValidator = PatternValidator(r'\d+?$', errorText: "PIN should be number");
  final gstValidator = RequiredValidator(errorText: 'GST is required');
  final creditPeriodValidator = MultiValidator([
    RequiredValidator(errorText: 'Credit Period is required'),
    PatternValidator(r'\d+?$', errorText: "Credit Period should be number"),
  ]);


  @override
  void initState() {
    super.initState();
    customerIdController = TextEditingController(text: widget.customer.id.toString());
     companyController = TextEditingController(text: widget.customer.company_name);
     contactPersonController = TextEditingController(text: widget.customer.contact_person);
     addressController = TextEditingController(text: widget.customer.address);
     pinController = TextEditingController(text: widget.customer.pin.toString());
     cityController = TextEditingController(text: widget.customer.city);
     stateController = TextEditingController(text: widget.customer.state);
     stateCodeController = TextEditingController(text: widget.customer.stateCode);
     gstController = TextEditingController(text: widget.customer.gst);
     creditPeriodController = TextEditingController(text: widget.customer.creditPeriod.toString());


  }
  @override
  Widget build(BuildContext context) {
    containerWidth = (MediaQuery
        .of(context)
        .size
        .width - KVariables.sidebarWidth);
    // if(widget.id == 0){
    //   customer = Customer(company_name: "");
      return _createCustomer();
    // }
//     else{
//       return Consumer<CustomerProvider>(builder: (ctx, provider, child) {
//         return FutureBuilder(
//           future: provider.getCustomerWithId(widget.id),
//           builder: (context, AsyncSnapshot<Customer> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else {
//               if (snapshot.hasError) {
// //                  if (snapshot.error is ConnectivityError) {
// //                    return NoConnectionScreen();
// //                  }
//                 return Center(child: Text("An error occured.\n$snapshot"));
//                 // return noData(context);
//               } else if (snapshot.hasData) {
//                 customer = snapshot.data!;
//
//               } else
//                 customer = Customer(company_name: "");
//
//             }
//             return _createCustomer();
//           },
//         );
//       });
//     }

  }

  Widget _createCustomer(){
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      // backgroundColor: Color.fromRGBO(242,243,247,1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      content:  Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(242,243,247,1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.zero, bottomRight: Radius.zero),
              ),
              width:  containerWidth,
              // height: containerHeight,
              child: AlertDialogNav(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New Customer",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KTextField(label: "Company name *", width: 250,controller: companyController, validator: companyNameValidator, ),
                ),
                Container(
                  child: KTextField(label: "Contact Person", width: 250, controller: contactPersonController,),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: KTextField(label: "Address", width: 250, multiLine: 8, controller: addressController,),
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      KTextField(label: "PIN", width: 250, controller: pinController, validator: pinValidator,),
                      SizedBox(height: 8,),
                      KTextField(label: "City", width: 250, controller: cityController,),
                      SizedBox(height: 8,),
                      KTextField(label: "State", width: 250, controller: stateController,),
                      SizedBox(height: 8,),
                      KTextField(label: "State Code", width: 250, controller: stateCodeController,),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: KTextField(label: "GST Number *", width: 250, controller: gstController, validator: gstValidator,),
                ),
                Container(
                  child: KTextField(label: "Credit Period *", width: 250, controller: creditPeriodController, validator: creditPeriodValidator,),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: resetForm,
                    child: Text("Reset"),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void resetForm(){
    setState(() {
      customerIdController.text = "";
      companyController.text = "";
      contactPersonController.text = "";
      addressController.text = "";
      pinController.text = "";
      cityController.text = "";
      stateController.text = "";
      stateCodeController.text = "";
      gstController.text = "";
      creditPeriodController.text = "";
    });
  }

  void submitForm(){
    if(_formKey.currentState!.validate()){
      // Customer customer = Customer(

        widget.customer.company_name = companyController.text;
        widget.customer.contact_person = contactPersonController.text;
        widget.customer.contact_phone= contactPersonController.text;  //Have to add Phone and Active Status fields on the page
        widget.customer.address= addressController.text;
        widget.customer.pin= int.parse(pinController.text);
        widget.customer.city= cityController.text;
        widget.customer.state=  stateController.text;
        widget.customer.stateCode= stateCodeController.text;
        widget.customer.gst= gstController.text;
        widget.customer.creditPeriod= int.parse(creditPeriodController.text);

      // print(customer);
      print("ID: ${widget.customer.id}");
      if(widget.customer.id != 0){
        Provider.of<CustomerProvider>(context, listen: false).updateCustomer(widget.customer);
        print("Customer Updated");
      }
      else{
        Provider.of<CustomerProvider>(context, listen: false).createCustomer(widget.customer);
      }
      Navigator.of(context).pop();
    }
    else{
      print("Validation Failed");
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose

    customerIdController.dispose();
    super.dispose();
  }
}


