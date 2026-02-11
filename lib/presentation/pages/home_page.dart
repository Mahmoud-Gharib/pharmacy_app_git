import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_app/core/constants/app_constants.dart';
import 'package:pharmacy_app/core/theme/app_colors.dart';
import 'package:pharmacy_app/core/theme/app_text_styles.dart';
import 'package:pharmacy_app/presentation/providers/language_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? 'لوحة التحكم' : 'Dashboard',
          style: AppTextStyles.headingSmall(isArabic: isArabic)
              .copyWith(color: Colors.white),
        ),
        actions: [
          // Language Toggle Button
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return TextButton.icon(
                onPressed: () => languageProvider.toggleLanguage(),
                icon: const Icon(Icons.language, color: Colors.white, size: 20),
                label: Text(
                  languageProvider.isArabic ? 'EN' : 'AR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic
                                    ? 'مرحباً، صيدلي'
                                    : 'Welcome, Pharmacist',
                                style: AppTextStyles.bodyMedium(
                                        isArabic: isArabic)
                                    .copyWith(
                                        color: Colors.white.withOpacity(0.9)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic ? 'صيدلية النور' : 'Al-Nour Pharmacy',
                                style: AppTextStyles.headingSmall(
                                        isArabic: isArabic)
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildStatCard(
                    icon: Icons.shopping_cart,
                    title: isArabic ? 'طلبات اليوم' : "Today's Orders",
                    value: '24',
                    color: AppColors.primary,
                    isArabic: isArabic,
                  ),
                  _buildStatCard(
                    icon: Icons.attach_money,
                    title: isArabic ? 'إجمالي المبيعات' : 'Total Sales',
                    value: '2,450',
                    color: AppColors.success,
                    isArabic: isArabic,
                  ),
                  _buildStatCard(
                    icon: Icons.warning_amber,
                    title: isArabic ? 'مخزون منخفض' : 'Low Stock',
                    value: '8',
                    color: AppColors.warning,
                    isArabic: isArabic,
                  ),
                  _buildStatCard(
                    icon: Icons.event_busy,
                    title: isArabic ? 'تنتهي قريباً' : 'Expiring Soon',
                    value: '5',
                    color: AppColors.error,
                    isArabic: isArabic,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Quick Actions
              Text(
                isArabic ? 'إجراءات سريعة' : 'Quick Actions',
                style: AppTextStyles.headingSmall(isArabic: isArabic),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.add_shopping_cart,
                      label: isArabic ? 'طلب جديد' : 'New Order',
                      onTap: () => Navigator.pushNamed(
                          context, AppConstants.ordersRoute),
                      isArabic: isArabic,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.medication,
                      label: isArabic ? 'إضافة دواء' : 'Add Medicine',
                      onTap: () {},
                      isArabic: isArabic,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.people,
                      label: isArabic ? 'عميل جديد' : 'New Customer',
                      onTap: () {},
                      isArabic: isArabic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Recent Orders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isArabic ? 'أحدث الطلبات' : 'Recent Orders',
                    style: AppTextStyles.headingSmall(isArabic: isArabic),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppConstants.ordersRoute),
                    child: Text(
                      isArabic ? 'عرض الكل' : 'View All',
                      style: AppTextStyles.bodyMedium(isArabic: isArabic)
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildOrderCard(
                orderId: '#ORD-2024-001',
                customer: isArabic ? 'أحمد محمد' : 'Ahmed Mohamed',
                amount: 'EGP 250.00',
                status: 'completed',
                isArabic: isArabic,
              ),
              _buildOrderCard(
                orderId: '#ORD-2024-002',
                customer: isArabic ? 'فاطمة علي' : 'Fatima Ali',
                amount: 'EGP 180.50',
                status: 'pending',
                isArabic: isArabic,
              ),
              _buildOrderCard(
                orderId: '#ORD-2024-003',
                customer: isArabic ? 'محمد حسن' : 'Mohamed Hassan',
                amount: 'EGP 420.00',
                status: 'completed',
                isArabic: isArabic,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headingMedium(isArabic: isArabic)
                .copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall(isArabic: isArabic)
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isArabic,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall(isArabic: isArabic)
                  .copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String customer,
    required String amount,
    required String status,
    required bool isArabic,
  }) {
    Color statusColor;
    switch (status) {
      case 'completed':
        statusColor = AppColors.success;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: AppTextStyles.bodyLarge(isArabic: isArabic)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  customer,
                  style: AppTextStyles.bodyMedium(isArabic: isArabic)
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.bodyLarge(isArabic: isArabic).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTextStyles.bodySmall(isArabic: isArabic).copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
