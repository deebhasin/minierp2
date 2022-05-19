import 'package:desktop_window/desktop_window.dart';
import 'package:erpapp/screens/organization_view.dart';
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

class ViewScreen extends StatefulWidget {
  const ViewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late Organization _org;
  String displayPage = "Dashboard";
  static const int _sidebarWidth = 200;

  @override
  void initState() {
    _getOrg();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getOrg();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _getOrg() async{
    _org = Provider.of<OrgProvider>(context, listen: false).getOrg;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
      return  _org.id == 0? OrganizationCreate(org: _org, reFresh: _refreshPage,) : body();
    // return OrganizationCreate(org: _org, reFresh: _refreshPage,);
    // return body();
  }

  Widget body() {
    _getOrg();
    String _companyName = _org.name;
    String _companyLogo = _org.logo;
    print("View Screen REfresh: ${_companyLogo}");
    _setDesktopFullScreen();

    Widget dynamicPage() {
      Widget displayWidget;
      switch (displayPage) {
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
              reFresh: _refreshPage,
            );
          }
          break;

        default:
          displayWidget = Center(
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

    void setDisplayPage(String selection) {
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
            Sidebar(
              sidebarWidth: _sidebarWidth,
              setDisplayPage: setDisplayPage,
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

  void _refreshPage(){
    setState(() {
      print("Refreshing View Screen");
    });
  }

  _setDesktopFullScreen() {
    DesktopWindow.setFullScreen(true);
  }
}
