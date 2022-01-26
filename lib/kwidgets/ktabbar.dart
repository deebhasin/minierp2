import 'package:flutter/material.dart';

import '../widgets/secondtab.dart';

class KTabBar extends StatefulWidget {
  final int sidebar;
  static double sizedBoxWidth = 200;
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
    KTabBar.sizedBoxWidth = (MediaQuery.of(context).size.width - widget.sidebar) * 0.85;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
          // height: 30,
          width: (MediaQuery.of(context).size.width - widget.sidebar) *0.243,
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
                      // indicatorPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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

        const Divider(
          color: Colors.grey,
          height: 0,
        ),
        Column(
          children: [
            SizedBox(
              height: 650,
              // width: (MediaQuery.of(context).size.width - widget.sidebar) * 0.85,
              width: KTabBar.sizedBoxWidth,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.red),
              // ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Center(
                      child: Text(
                        "We Have to get Somethings done here.\n Don't know what Yet",              /// Index:0
                        style: TextStyle(fontSize: 20),
                      )),
                  SecondTab(sidebar: widget.sidebar,),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
