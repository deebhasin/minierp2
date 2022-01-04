import 'package:erpapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProvider {
	static List<SingleChildWidget> get() {
		return [

			Provider<AuthProvider>(create: (_) => AuthProvider()),
	];
	}
}
