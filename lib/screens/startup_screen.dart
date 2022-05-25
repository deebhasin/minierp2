import 'dart:async';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/organization.dart';
import '../providers/customer_provider.dart';
import '../providers/product_provider.dart';
import '/screens/loadscreen.dart';
import '/screens/home_screen.dart';

import '../providers/org_provider.dart';
import '../utils/localDB_repo.dart';

class HomePage extends StatelessWidget {

  Future<void> initApp(BuildContext context) async {
    bool newDb = await LocalDBRepo().init(forceRebuild: false);
    await Provider.of<CustomerProvider>(context, listen: false).cacheCustomer();
    await Provider.of<ProductProvider>(context, listen: false).cacheProductList();
    await Provider.of<OrgProvider>(context, listen: false).cacheOrg();
    // if (newDb) await _OrgProvider.insertOrganization();
    // organization = await _OrgProvider.getOrganization();
  }

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // _getOrg();
    return Scaffold(
      // appBar: AppBar(),
      body: FutureBuilder<void>(
        future: initApp(context), // a previously-obtained Future<String> or null
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // if(snapshot.hasData){
            return HomeScreen();
            // }
          }
          _setDesktopFullScreen();
          return LoadScreen();
        },
      ),
    );
  }
  _setDesktopFullScreen() {
    DesktopWindow.setFullScreen(true);
  }
}
