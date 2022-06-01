import 'package:erpapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kwidgets/kdropdown.dart';
import '../kwidgets/kcreatebutton.dart';
import '../model/organization.dart';
import '../providers/customer_provider.dart';
import '../providers/org_provider.dart';
import '../providers/product_provider.dart';
import '../utils/localDB_repo.dart';
import '../utils/logfile.dart';
import '../model/master_organization.dart';
import 'organization_create.dart';

class OrganizationMasterView extends StatelessWidget {
  final List<MasterOrganization> masterOrgList;
  String _selectedOrg = "";
  OrganizationMasterView({
    Key? key,
    required this.masterOrgList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: Color.fromRGBO(63, 64, 66, 1),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Color.fromRGBO(63, 64, 66, 1),
            child: Image.asset(
              "asset/images/minierp_logo.png",
              width: 300,
              // fit: BoxFit.fill,
              // width: 100,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Welcome to Mini ERP",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Select Company",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KDropdown(
                dropDownList: masterOrgList
                    .map((masterOrg) => masterOrg.orgName)
                    .toList(),
                label: "Company",
                width: 300,
                isShowSearchBox: false,
                onChangeDropDown: _selectOrg,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          KCreateButton(
            callFunction: () => _createOrg(context),
          ),
          Container(
            width: 300,
            child: ElevatedButton(
              onPressed: () => _initOrg(context),
              child: Text(
                "Enter",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectOrg(String selection) {
    _selectedOrg = selection;
    print("Selected Org: $_selectedOrg");
  }

  void _initOrg(BuildContext context) async {
    if(_selectedOrg != "") {
      try {
        bool newDb = await LocalDBRepo()
            .initDB(dbName: _selectedOrg, forceRebuild: false);
        newDb
            ? LogFile().logEntry("Database Created.")
            : LogFile().logEntry("Database Exists.");
      } catch (e) {
        LogFile().logEntry("Error: $e");
      }
      await Provider.of<CustomerProvider>(context, listen: false)
          .cacheCustomer();
      await Provider.of<ProductProvider>(context, listen: false)
          .cacheProductList();
      await Provider.of<OrgProvider>(context, listen: false).cacheOrg();
    }
    Navigator.of(context).pop();
    Navigator.pushNamed(context, "homeScreen");
  }

  void _createOrg(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, "homeScreen");
  }
}
