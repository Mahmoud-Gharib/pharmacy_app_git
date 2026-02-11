// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'صيدلية برو';

  @override
  String get welcome => 'مرحباً';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get signin => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get home => 'الرئيسية';

  @override
  String get orders => 'الطلبات';

  @override
  String get medicines => 'الأدوية';

  @override
  String get customers => 'العملاء';

  @override
  String get reports => 'التقارير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get search => 'بحث';

  @override
  String get add => 'إضافة';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get success => 'نجاح';

  @override
  String get error => 'خطأ';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String orderNumber(Object number) {
    return 'طلب رقم $number';
  }

  @override
  String get orderDate => 'تاريخ الطلب';

  @override
  String get customerName => 'اسم العميل';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get status => 'الحالة';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get completed => 'مكتمل';

  @override
  String get cancelled => 'ملغي';

  @override
  String get medicineName => 'اسم الدواء';

  @override
  String get quantity => 'الكمية';

  @override
  String get price => 'السعر';

  @override
  String get description => 'الوصف';

  @override
  String get category => 'الفئة';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get welcomeMessage => 'حلول إدارة الصيدلية الشاملة';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get previous => 'السابق';

  @override
  String get finish => 'إنهاء';

  @override
  String get createOrder => 'إنشاء طلب';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get addMedicine => 'إضافة دواء';

  @override
  String get medicineDetails => 'تفاصيل الدواء';

  @override
  String get inventory => 'المخزون';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get todayOrders => 'طلبات اليوم';

  @override
  String get totalSales => 'إجمالي المبيعات';

  @override
  String get lowStock => 'مخزون منخفض';

  @override
  String get expiringSoon => 'تنتهي صلاحيته قريباً';
}
