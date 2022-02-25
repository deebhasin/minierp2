import 'package:erpapp/domain/organization.dart';
import 'package:erpapp/providers/org_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kcreatebutton.dart';
import '../kwidgets/ktablecellheader.dart';


class ViewCustomers extends StatelessWidget {
  final double width;

  ViewCustomers({Key? key,
    required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // late OrgProvider _orgProvider;
    late Organization _org;

    return Consumer<OrgProvider>(builder: (ctx, provider, child) {
      return FutureBuilder(
        future: provider.getOrganization(),
        builder: (context, AsyncSnapshot<Organization> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: const CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
//                  if (snapshot.error is ConnectivityError) {
//                    return NoConnectionScreen();
//                  }
              return Center(child: Text("An error occured"));
            } else if (snapshot.hasData) {
              _org = snapshot.data!;
              print("in customer ${_org.name}");
              return body(context);
            } else
              return Container();
          }
        },
      );
    });
  }

  Widget body(BuildContext context) {
    double containerWidth = width * 0.95;
    return Column(
      children: [
        const KCreateButton(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Customer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KTableCellHeader(header: "#", context: context, cellWidth: containerWidth *.03,),
              KTableCellHeader(header: "Company Name", context: context, cellWidth: containerWidth * 0.18,),
              KTableCellHeader(header: "Contact Person", context: context, cellWidth: containerWidth * 0.14,),
              KTableCellHeader(header: "Mobile", context: context, cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: "Address", context: context, cellWidth: containerWidth * 0.14,),
              // KTableCellHeader(header: "Pin", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: "City", context: context, cellWidth: containerWidth * .1,),
              KTableCellHeader(header: "State", context: context, cellWidth: containerWidth * 0.1,),
              // KTableCellHeader(header: "State Code", context: context, cellWidth: containerWidth * 0.05,),
              KTableCellHeader(header: "GST Number", context: context, cellWidth: containerWidth * 0.1,),
              KTableCellHeader(header: "Credit Period", context: context, cellWidth: containerWidth *.1,),
              KTableCellHeader(header: "Status", context: context, cellWidth: containerWidth *.05, isLastPos: true,),
            ],
        ),
      ],
    );
  }
}
