import 'package:desktop_window/desktop_window.dart';
import 'package:erpapp/utils/logfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../providers/customer_provider.dart';
import '../providers/product_provider.dart';
import '/screens/loadscreen.dart';
import '/screens/home_screen.dart';

import '../providers/org_provider.dart';
import '../utils/localDB_repo.dart';

class StartupScreen extends StatefulWidget {
  StartupScreen({Key? key}) : super(key: key);

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {

  Future<void> initApp(BuildContext context) async {
    await LogFile().init();
    try {
      bool newDb = await LocalDBRepo().init(forceRebuild: false);
      LogFile().logEntry("Database Created.");
    } catch (e) {
        LogFile().logEntry(e);
    }
    await Provider.of<CustomerProvider>(context, listen: false).cacheCustomer();
    await Provider.of<ProductProvider>(context, listen: false)
        .cacheProductList();
    await Provider.of<OrgProvider>(context, listen: false).cacheOrg();


    // if (newDb) await _OrgProvider.insertOrganization();
    // organization = await _OrgProvider.getOrganization();
  }

  @override
  Widget build(BuildContext context) {
    // _getOrg();
    return Scaffold(
      // appBar: AppBar(),
      body: FutureBuilder<void>(
        future:
            initApp(context), // a previously-obtained Future<String> or null
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
