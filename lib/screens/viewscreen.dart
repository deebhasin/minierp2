import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import '../widgets/company_logo_name.dart';
import '../widgets/top_nav.dart';
import '../kwidgets/ktabbar.dart';

import '../widgets/sidebar.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    const   int _sidebarWidth = 200;
    const String _companyName = "iTuple Technologies Pvt. Ltd.";
    const String _companyLogo = "asset/images/company_logo.jpg";
    _setDesktopFullScreen();
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Sidebar(sidebarWidth: _sidebarWidth),
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
                children: const[
                  TopNavBar(sidebar: _sidebarWidth),
                  CompanyLogoName(sidebarWidth: _sidebarWidth, companyLogo: _companyLogo, companyName: _companyName),
                  KTabBar(sidebar: _sidebarWidth,),

                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  // height: 30,
                  width: (MediaQuery.of(context).size.width - _sidebarWidth),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(63, 64, 66, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.copyright,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            "iTuple Technologies Pvt. Ltd.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
