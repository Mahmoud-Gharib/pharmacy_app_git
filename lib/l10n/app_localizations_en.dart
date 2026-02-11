// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Pharmacy Pro';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signup => 'Sign Up';

  @override
  String get signin => 'Sign In';

  @override
  String get logout => 'Logout';

  @override
  String get home => 'Home';

  @override
  String get orders => 'Orders';

  @override
  String get medicines => 'Medicines';

  @override
  String get customers => 'Customers';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get search => 'Search';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No Data Available';

  @override
  String get tryAgain => 'Try Again';

  @override
  String orderNumber(Object number) {
    return 'Order #$number';
  }

  @override
  String get orderDate => 'Order Date';

  @override
  String get customerName => 'Customer Name';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get status => 'Status';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get medicineName => 'Medicine Name';

  @override
  String get quantity => 'Quantity';

  @override
  String get price => 'Price';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get phone => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get welcomeMessage => 'Your Complete Pharmacy Management Solution';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get finish => 'Finish';

  @override
  String get createOrder => 'Create Order';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get addMedicine => 'Add Medicine';

  @override
  String get medicineDetails => 'Medicine Details';

  @override
  String get inventory => 'Inventory';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get todayOrders => 'Today\'s Orders';

  @override
  String get totalSales => 'Total Sales';

  @override
  String get lowStock => 'Low Stock Items';

  @override
  String get expiringSoon => 'Expiring Soon';
}
