import 'package:erpapp/providers/auth_provider.dart';
import 'package:erpapp/providers/customer_provider.dart';
import 'package:erpapp/providers/org_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProvider {
	static List<SingleChildWidget> get() {
		return [

			ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
			ChangeNotifierProvider<OrgProvider>(create: (_) => OrgProvider()),
			ChangeNotifierProvider<CustomerProvider>(create: (_) => CustomerProvider()),
	];
	}
}
