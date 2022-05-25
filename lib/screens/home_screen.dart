import 'package:desktop_window/desktop_window.dart';
import 'package:erpapp/providers/home_screen_provider.dart';
import 'package:erpapp/screens/organization_view.dart';
import 'package:erpapp/screens/report_view.dart';
import 'package:erpapp/screens/test_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/company_logo_name.dart';
import '../widgets/top_nav.dart';
import '../kwidgets/ktabbar.dart';
import '../widgets/footer.dart';
import '../screens/challanview.dart';
import '../screens/customersview.dart';
import '../model/organization.dart';
import '../providers/org_provider.dart';
import '../screens/productview.dart';
import '../screens/invoiceview.dart';

import '../widgets/sidebar.dart';
import 'organization_create.dart';

class HomeScreen extends StatefulWidget {
  String displayPage;

  HomeScreen({
    Key? key,
    this.displayPage = "Report",
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Organization _org;
  late String _selection;
  static const int _sidebarWidth = 200;




  @override
  Widget build(BuildContext context) {
    _org = Provider.of<OrgProvider>(context, listen: true).getOrg;
    _selection = Provider.of<HomeScreenProvider>(context).getDisplayPage;
      // return  _org.id == 0? OrganizationCreate(org: _org) : body();
    // return  TestDB(title: "Test DB",);
    // return OrganizationCreate(org: _org, reFresh: _refreshPage,);
    return body();
  }

  Widget body() {
    String _companyName = _org.name;
    String _companyLogo = _org.logo;
    print("View Screen REfresh: ${_companyLogo}");
    _setDesktopFullScreen();

    Widget dynamicPage() {
      Widget displayWidget;
      switch (_selection) {
        case "Dashboard":
          {
            displayWidget = const KTabBar(
              sidebar: _sidebarWidth,
            );
          }
          break;
        case "Challan":
          {
            displayWidget = ViewChallan(
              width: (MediaQuery.of(context).size.width - _sidebarWidth),
            );
          }
          break;
        case "Invoice":
          {
            displayWidget = InvoiceView(
              width: (MediaQuery.of(context).size.width - _sidebarWidth),
            );
          }
          break;
          // case "Payments" :
          //   {
          //     displayWidget = const ViewChallan();
          //   }

          break;
        case "Customers":
          {
            displayWidget = CustomersView(
              width: (MediaQuery.of(context).size.width - _sidebarWidth),
            );
          }
          break;

        case "Products":
          {
            displayWidget = ProductsView(
              width: (MediaQuery.of(context).size.width - _sidebarWidth),
            );
          }
          break;

        case "Organization":
          {
            displayWidget = OrganizationView(
              width: (MediaQuery.of(context).size.width - _sidebarWidth),
            );
          }
          break;

        case "Reports":
          {
            displayWidget = ReportView(
              width: (MediaQuery.of(context).size.width - _sidebarWidth),
            );
          }
          break;

        default:
          displayWidget = Center(
            child: Text(
              "No Selection Made OR Page for $_selection not Created",
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



    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Sidebar(
              sidebarWidth: _sidebarWidth,
              selection: _selection,
            ),
          ],
        ),
        Container(
          width: (MediaQuery.of(context).size.width - _sidebarWidth),
          height: (MediaQuery.of(context).size.height),
          child: Stack(
            // STACK IS CREATED SO THAT THE FOOTER CAN BE POSITIONED
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopNavBar(sidebar: _sidebarWidth),
                  CompanyLogoName(
                      sidebarWidth: _sidebarWidth,
                      companyLogo: _companyLogo,
                      companyName: _companyName),
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
