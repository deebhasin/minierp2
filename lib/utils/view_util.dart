class ViewUtils {
  // Making this class Singleton
  static final ViewUtils _singleton = ViewUtils._internal();

  factory ViewUtils() {
    return _singleton;
  }

  ViewUtils._internal();

  late String _selectedPage = "Dashboard";

  String get selectedPage {
    return _selectedPage;
  }
  void set selectedPage (String selectedPage) {
     _selectedPage = selectedPage;
  }

}