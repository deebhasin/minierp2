import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import '../widgets/company_logo_name.dart';
import '../widgets/top_nav.dart';
import '../kwidgets/ktabbar.dart';
import '../widgets/footer.dart';

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
