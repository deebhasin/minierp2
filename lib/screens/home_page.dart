import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/organization.dart';
import '/screens/loadscreen.dart';
import '/screens/viewscreen.dart';

import '../providers/org_provider.dart';
import '../utils/localDB_repo.dart';

class HomePage extends StatelessWidget {
  late OrgProvider _OrgProvider;
  Organization organization = Organization();

  Future<void> initApp() async {
    bool newDb = await LocalDBRepo().init(forceRebuild: false);
    // if (newDb) await _OrgProvider.insertOrganization();
    // organization = await _OrgProvider.getOrganization();
  }

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _OrgProvider = Provider.of<OrgProvider>(context, listen: false);
    // _getOrg();
    return Scaffold(
      // appBar: AppBar(),
      body: FutureBuilder<void>(
        future: initApp(), // a previously-obtained Future<String> or null
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // if(snapshot.hasData){
            return ViewScreen();
            // }
          }
          return LoadScreen();
        },
      ),
    );
  }

  void _getOrg() async {
    await _OrgProvider.getOrganization();
  }
}
