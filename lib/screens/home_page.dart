import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/loadscreen.dart';
import '/screens/viewscreen.dart';

import '../providers/org_provider.dart';
import '../utils/localDB_repo.dart';


class HomePage extends StatelessWidget {

  late OrgProvider _OrgProvider;
  Future<void> initApp() async{
    bool newDb = await LocalDBRepo().init(forceRebuild: false);
    if(newDb) await _OrgProvider.insertOrganization();

  }

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _OrgProvider = Provider.of<OrgProvider>(context, listen: false);
    return Scaffold(
      // appBar: AppBar(),
      body: FutureBuilder<void>(
        future: initApp(), // a previously-obtained Future<String> or null
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            // if(snapshot.hasData){
              return const ViewScreen();
            // }
          }
          return LoadScreen();
        },
      ),
    );
  }
}
