import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/company_logo_name.dart';
import '../widgets/top_nav.dart';
import '../kwidgets/ktabbar.dart';
import '../widgets/footer.dart';
import '../screens/viewchallan.dart';

import '../widgets/sidebar.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);


  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  String displayPage = "Dashboard";
  @override
  Widget build(BuildContext context) {
    const int _sidebarWidth = 200;
    const String _companyName = "iTuple Technologies Pvt. Ltd.";
    const String _companyLogo = "asset/images/company_logo.jpg";
    _setDesktopFullScreen();

    Widget dynamicPage(){
      Widget displayWidget;
      switch(displayPage){
        case "Dashboard" :
          {
            displayWidget = const KTabBar(
              sidebar: _sidebarWidth,
            );
          }
          break;
        case "Challan" :
          {
            displayWidget = const ViewChallan();
          }
          break;
        default: displayWidget = Center(
          child: Text(
            "No Selection Made OR Page for $displayPage not Created",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        );
      }
      return displayWidget;
    }

    void setDisplayPage(String selection){
      setState(() {
        displayPage = selection;
      });
    }

    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Sidebar(sidebarWidth: _sidebarWidth, setDisplayPage: setDisplayPage,),
          ],
        ),
        Container(
          width: (MediaQuery.of(context).size.width - _sidebarWidth),
          height: (MediaQuery.of(context).size.height),
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.red),
          // ),
          child: Stack( // STACK IS CREATED SO THAT THE FOOTER CAN BE POSITIONED
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopNavBar(sidebar: _sidebarWidth),
                  const CompanyLogoName(sidebarWidth: _sidebarWidth, companyLogo: _companyLogo, companyName: _companyName),
                  // KTabBar(sidebar: _sidebarWidth,),
                  dynamicPage(),

                ],
              ),
              const Positioned(
                bottom: 0,
                child: KFooter(sidebarWidth: _sidebarWidth),
              ),
            ],
          ),
        ),

      ],
    );
  }

  _setDesktopFullScreen() {
     DesktopWindow.setFullScreen(true);
  }
}
