import 'package:erpapp/kwidgets/kchallanbutton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../kwidgets/kvariables.dart';
import '../kwidgets/ktextfield.dart';
import '../kwidgets/kdropdown.dart';
import '../kwidgets/kdropdownfield.dart';
import '../kwidgets/ktablecellheader.dart';
import '../kwidgets/ktablecell.dart';

class CreateChallan extends StatefulWidget {
  const CreateChallan({Key? key}) : super(key: key);

  @override
  State<CreateChallan> createState() => _CreateChallanState();
}

class _CreateChallanState extends State<CreateChallan> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = "-----";
  final currencyFormat = NumberFormat("#,##0.00", "en_US");
  double challanAmount = 0;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    const int challanNumber = 001;
    const String financialYear = "2021-2022";
    double containerWidth = (MediaQuery.of(context).size.width - KVariables.sidebarWidth);
    const double inputComponentWidth = 200;
    const String email = "billing@ituple.com";
    const String billingAddress = "Mr. Avtar\nI Provide Solution India\nIprovide House, Opp. Indian Oil Petrol Pump, Near Omaxe City,\nNH-2";
    const String customerName = "I Provide Soluiton India";
    const String placeOfSupply = "Haryana";
    const String status = "Pending";
    const String estimateDate = "03/02/2022";
    const String estimateNo = "1001";
    const String amountType = "Exclusive of Tax";
    const double subtotal = 0;
    const double total = 0;
    const double challantotal = 0;

    const List<String> customerList = [
      "I Provide Solution India",
      "Alfa Bottle",
      "Beta Pharma",
      "Cat Stevens",
      "Rock the Boat",
      "Mitch Mitchell",
    ];

    const List<String> statusList = [
      // "-----",
      "Pending",
      "Complete",
      "Active",
      "Suspended",
    ];

    const List<String> stateList = [
      // "-----",
      "Punjab",
      "Haryana",
      "Maharashtra",
      "Kerela",
    ];

    const List<String> amountTypeList = [
      // "-----",
      "Inclusive of Tax",
      "Exclusive of Tax",
      "Exempted from Tax",
    ];




    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      content: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(242,243,247,1)),
        width: containerWidth,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width:  containerWidth,
                // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "asset/images/back_arrow.png",
                              width: 20,
                            ),
                          ),
                          const Text(
                            "Challan No. $challanNumber/$financialYear",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
              Container(
                width: containerWidth * 0.95,
               padding: const EdgeInsets.all(10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const KDropdown(dropDownList: customerList, label: "Customer", initialValue: customerName, width: 250,),
                            Container(
                              width: 300,
                              // height: 10,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 10,
                                        backgroundColor: Colors.amber,
                                        child: Image.asset("asset/images/clock_32.png", width: 15,color: Colors.white,),
                                    ),
                                  ),
                                  // SizedBox(width: 10,),
                                  KDropDownField(dropDownList: statusList, label: "", initialValue: status, height: 20, width: 100,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            KTextField(label: "Email", initialValue: email, width: 150,),
                            Container(
                              padding: EdgeInsets.zero,
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                    child: Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value){
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "Send later",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                            "Amount",
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          "\u{20B9}${currencyFormat.format(challanAmount)}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: containerWidth *0.95,
                padding: const EdgeInsets.all(10),
                // height: 20,
                // color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KTextField(label: "Billing address", initialValue: billingAddress, width: 150, multiLine: 6,),
                        const SizedBox(height: 10,),
                        KDropDownField(dropDownList: stateList, label: "Place of Supply", initialValue: placeOfSupply, height: 20, width: 100,),
                      ],
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        KTextField(label: "Estimate Date", initialValue: estimateDate, width: 150,),
                        const SizedBox(height: 30,),
                        KTextField(label: "LUT No.", width: 150,),
                      ],
                    ),
                    const SizedBox(width: 90,),
                    KTextField(label: "Expiration Date", width: 150,),

                    const SizedBox(width: 430,),
                    KTextField(label: "Challan no.", initialValue: estimateNo, width: 150,),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: containerWidth,
                height: 365,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: containerWidth *0.95,
                      height: 25,
                      // color: Colors.red,
                      child: Row(
                        children: [
                          SizedBox(
                            width: containerWidth * 0.95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                  const Text(
                                    "Amounts Are ",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                KDropDownField(dropDownList: amountTypeList,width: 110, initialValue: amountType, label: ""),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      width: containerWidth * 0.95,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              KTableCellHeader(pos: 1, header: "", context: context),
                              KTableCellHeader(pos: 2, header: "#", context: context),
                              KTableCellHeader(pos: 3, header: "PRODUCT/SERVICE", context: context),
                              KTableCellHeader(pos: 4, header: "HSN/SAC", context: context),
                              KTableCellHeader(pos: 5, header: "DESCRIPTION", context: context),
                              KTableCellHeader(pos: 6, header: "QTY", context: context),
                              KTableCellHeader(pos: 7, header: "RATE", context: context),
                              KTableCellHeader(pos: 8, header: "AMOUNT (\u{20B9})", context: context),
                              KTableCellHeader(pos: 9, header: "TAX", context: context),
                              KTableCellHeader(pos: 10, header: "", context: context),
                            ],
                          ),
                          Row(
                            children: [
                              KTableCell(pos: 1, context: context),
                              KTableCell(pos: 2, parameterValue: "1", context: context),
                              KTableCell(pos: 3, dropdownList: customerList, context: context),
                              KTableCell(pos: 4, context: context),
                              KTableCell(pos: 5, context: context),
                              KTableCell(pos: 6, context: context),
                              KTableCell(pos: 7, context: context),
                              KTableCell(pos: 8, context: context),
                              KTableCell(pos: 9, dropdownList: statusList, context: context),
                              KTableCell(pos: 10, context: context),
                            ],
                          ),

                          Row(
                            children: [
                              KTableCell(pos: 1, context: context),
                              KTableCell(pos: 2, parameterValue: "2", context: context),
                              KTableCell(pos: 3, dropdownList: customerList, context: context),
                              KTableCell(pos: 4, parameterValue: "123456", context: context),
                              KTableCell(pos: 5, context: context),
                              KTableCell(pos: 6, context: context),
                              KTableCell(pos: 7, context: context),
                              KTableCell(pos: 8, context: context),
                              KTableCell(pos: 9, dropdownList: statusList, context: context),
                              KTableCell(pos: 10, context: context),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      width: containerWidth * 0.95,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    KChallanButton(label: "Add lines",),
                                    SizedBox(width: 10,),
                                    KChallanButton(label: "Clear all lines",),
                                    SizedBox(width: 10,),
                                    KChallanButton(label: "Add subtotal",),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                KTextField(label: "Message displayed on estimate", width: 200, multiLine: 4, ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text("Subtotal", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 20,),
                                  Text("Total", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 20,),
                                  Text("Challan Total", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              const SizedBox(width: 50,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(subtotal.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 20,),
                                  Text(total.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 20,),
                                  Text(challantotal.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              const SizedBox(width: 10,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: containerWidth,
              //   padding: const EdgeInsets.all(10),
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 350,
              //         // decoration: BoxDecoration(color: Colors.red),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             const KDropDownField(dropDownList: customerList, label: "Customer", width: 150,),
              //             KTextField(label: "Email", width: 150,),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
