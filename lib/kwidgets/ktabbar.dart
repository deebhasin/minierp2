import 'package:flutter/material.dart';

class KTabBar extends StatefulWidget {
  final int sidebar;
  const KTabBar({Key? key, required this.sidebar}) : super(key: key);

  @override
  _KTabBarState createState() => _KTabBarState();
}

class _KTabBarState extends State<KTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          // height: 30,
          width: 300,
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.red),
          // ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.green,
                      indicatorWeight: 5,
                      indicatorPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(
                          // height: 20,
                          text: 'Get things done',
                        ),
                        Tab(
                          // height: 20,
                          text: 'Business overview',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: 200,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.red),
              // ),
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Center(
                      child: Text(
                        "We Have to get Somethings done here.\n Don't know what Yet",              /// Index:0
                        style: TextStyle(fontSize: 20),
                      )),
                  Center(
                      child: Text(
                        'Business overview Constructor will come here',                     /// Index:1
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
