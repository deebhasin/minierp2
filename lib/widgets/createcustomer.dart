import 'package:erpapp/domain/customer.dart';
import 'package:erpapp/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/ktextfield.dart';
import '../kwidgets/kvariables.dart';

class CreateCustomer extends StatefulWidget {
  const CreateCustomer({Key? key}) : super(key: key);

  @override
  State<CreateCustomer> createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
  @override
  Widget build(BuildContext context) {
    double containerWidth = (MediaQuery.of(context).size.width - KVariables.sidebarWidth);
    double containerHeight = 700;
    final _formKey = GlobalKey<FormState>();
    final customerIdController = TextEditingController();
    final companyController = TextEditingController();
    final contactPersonController = TextEditingController();
    final addressController = TextEditingController();
    final pinController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final stateCodeController = TextEditingController();
    final gstController = TextEditingController();
    final creditPeriodController = TextEditingController();

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
        Customer customer = Customer(
          name: companyController.text,
          contact: contactPersonController.text,
          address: addressController.text,
          pin: int.parse(pinController.text),
          city: cityController.text,
          state: stateController.text,
          stateCode: stateCodeController.text,
          gst: gstController.text,
          creditPeriod: int.parse(creditPeriodController.text),
        );

        Provider.of<CustomerProvider>(context, listen: false).createCustomer(customer);
      }
      else{
        print("Validation Failed");
      }
    }


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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.help_outline),
                        const Text("Help"),
                        InkResponse(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  child: KTextField(label: "Company name", width: 250,controller: companyController,),
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
                      KTextField(label: "PIN", width: 250, controller: pinController,),
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
                  child: KTextField(label: "GST Number", width: 250, controller: gstController,),
                ),
                Container(
                  child: KTextField(label: "Credit Period", width: 250, controller: creditPeriodController,),
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
}
