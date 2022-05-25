import 'package:erpapp/providers/home_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/auth_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/org_provider.dart';
import '../providers/product_provider.dart';
import '../providers/challan_provider.dart';
import '../providers/invoice_provider.dart';


class AppProvider {
	static List<SingleChildWidget> get() {
		return [

			ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
			ChangeNotifierProvider<OrgProvider>(create: (_) => OrgProvider()),
			ChangeNotifierProvider<CustomerProvider>(create: (_) => CustomerProvider()),
			ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider()),
			ChangeNotifierProvider<ChallanProvider>(create: (_) => ChallanProvider()),
			ChangeNotifierProvider<InvoiceProvider>(create: (_) => InvoiceProvider()),
			ChangeNotifierProvider<HomeScreenProvider>(create: (_) => HomeScreenProvider()),
	];
	}
}
