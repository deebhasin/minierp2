import 'package:desktop_window/desktop_window.dart';
import 'package:erpapp/utils/logfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/master_organization.dart';
import '../providers/home_screen_provider.dart';
import '/screens/loadscreen.dart';
import '/screens/home_screen.dart';

import '../providers/org_provider.dart';
import '../utils/localDB_repo.dart';
import 'organization_master_view.dart';

class StartupScreen extends StatefulWidget {
  StartupScreen({Key? key}) : super(key: key);

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {

  late List<MasterOrganization> _masterOrgList;

  Future<void> initApp(BuildContext context) async {
    await LogFile().init();
    try {
      bool newDb = await LocalDBRepo().initMasterDB(forceRebuild: false);
      newDb
          ? LogFile().logEntry("Database Created.")
          : LogFile().logEntry("Database Exists.");
    } catch (e) {
      LogFile().logEntry("Error: $e");
    }
    await Provider.of<OrgProvider>(context, listen: false).cacheMasterOrg();
    _masterOrgList = Provider.of<OrgProvider>(context, listen: true).getMasterOrgList;
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
            _masterOrgList = Provider.of<OrgProvider>(context, listen: true).getMasterOrgList;
            return OrganizationMasterView(masterOrgList: _masterOrgList);
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
