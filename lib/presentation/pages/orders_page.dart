import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/theme/app_colors.dart';
import 'package:pharmacy_app/core/theme/app_text_styles.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#ORD-2024-001',
      'customer': 'Ahmed Mohamed',
      'customerAr': 'أحمد محمد',
      'date': '2024-01-15',
      'amount': 'EGP 250.00',
      'status': 'completed',
      'items': 3,
    },
    {
      'id': '#ORD-2024-002',
      'customer': 'Fatima Ali',
      'customerAr': 'فاطمة علي',
      'date': '2024-01-15',
      'amount': 'EGP 180.50',
      'status': 'pending',
      'items': 2,
    },
    {
      'id': '#ORD-2024-003',
      'customer': 'Mohamed Hassan',
      'customerAr': 'محمد حسن',
      'date': '2024-01-14',
      'amount': 'EGP 420.00',
      'status': 'completed',
      'items': 5,
    },
    {
      'id': '#ORD-2024-004',
      'customer': 'Sara Ahmed',
      'customerAr': 'سارة أحمد',
      'date': '2024-01-14',
      'amount': 'EGP 95.00',
      'status': 'cancelled',
      'items': 1,
    },
    {
      'id': '#ORD-2024-005',
      'customer': 'Omar Khaled',
      'customerAr': 'عمر خالد',
      'date': '2024-01-13',
      'amount': 'EGP 310.75',
      'status': 'completed',
      'items': 4,
    },
  ];

  String _selectedFilter = 'all';

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

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilter == 'all') return _orders;
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? 'الطلبات' : 'Orders',
          style: AppTextStyles.headingSmall(isArabic: isArabic)
              .copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _showCreateOrderDialog(isArabic),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Filter Chips
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', isArabic ? 'الكل' : 'All', isArabic),
                    const SizedBox(width: 8),
                    _buildFilterChip('pending', isArabic ? 'قيد الانتظار' : 'Pending', isArabic),
                    const SizedBox(width: 8),
                    _buildFilterChip('completed', isArabic ? 'مكتمل' : 'Completed', isArabic),
                    const SizedBox(width: 8),
                    _buildFilterChip('cancelled', isArabic ? 'ملغي' : 'Cancelled', isArabic),
                  ],
                ),
              ),
            ),
            // Orders List
            Expanded(
              child: _filteredOrders.isEmpty
                ? _buildEmptyState(isArabic)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return _buildOrderCard(order, isArabic, index);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, bool isArabic) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      label: Text(
        label,
        style: AppTextStyles.bodyMedium(isArabic: isArabic).copyWith(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.textLight,
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, bool isArabic, int index) {
    final status = order['status'] as String;
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status, isArabic);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
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
        child: InkWell(
          onTap: () => _showOrderDetails(order, isArabic),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.primaryGradient,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['id'] as String,
                            style: AppTextStyles.bodyLarge(isArabic: isArabic)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic ? order['customerAr'] : order['customer'],
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
                          order['amount'] as String,
                          style: AppTextStyles.bodyLarge(isArabic: isArabic)
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: AppTextStyles.bodySmall(isArabic: isArabic)
                                .copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order['date'] as String,
                          style: AppTextStyles.bodySmall(isArabic: isArabic)
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${order['items']} ${isArabic ? 'منتجات' : 'items'}',
                          style: AppTextStyles.bodySmall(isArabic: isArabic)
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 60,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isArabic ? 'لا توجد طلبات' : 'No Orders Found',
            style: AppTextStyles.headingSmall(isArabic: isArabic)
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic 
              ? 'لا توجد طلبات متطابقة مع الفلتر المحدد'
              : 'No orders match the selected filter',
            style: AppTextStyles.bodyMedium(isArabic: isArabic)
                .copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status, bool isArabic) {
    switch (status) {
      case 'completed':
        return isArabic ? 'مكتمل' : 'COMPLETED';
      case 'pending':
        return isArabic ? 'قيد الانتظار' : 'PENDING';
      case 'cancelled':
        return isArabic ? 'ملغي' : 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }

  void _showOrderDetails(Map<String, dynamic> order, bool isArabic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    isArabic ? 'تفاصيل الطلب' : 'Order Details',
                    style: AppTextStyles.headingMedium(isArabic: isArabic),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    isArabic ? 'رقم الطلب' : 'Order ID',
                    order['id'] as String,
                    isArabic,
                  ),
                  _buildDetailRow(
                    isArabic ? 'العميل' : 'Customer',
                    isArabic ? order['customerAr'] : order['customer'],
                    isArabic,
                  ),
                  _buildDetailRow(
                    isArabic ? 'التاريخ' : 'Date',
                    order['date'] as String,
                    isArabic,
                  ),
                  _buildDetailRow(
                    isArabic ? 'الحالة' : 'Status',
                    _getStatusText(order['status'] as String, isArabic),
                    isArabic,
                    valueColor: _getStatusColor(order['status'] as String),
                  ),
                  _buildDetailRow(
                    isArabic ? 'المبلغ' : 'Amount',
                    order['amount'] as String,
                    isArabic,
                    valueColor: AppColors.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isArabic, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyLarge(isArabic: isArabic)
                .copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge(isArabic: isArabic).copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateOrderDialog(bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          isArabic ? 'إنشاء طلب جديد' : 'Create New Order',
          style: AppTextStyles.headingSmall(isArabic: isArabic),
        ),
        content: Text(
          isArabic 
            ? 'سيتم إضافة هذه الميزة قريباً'
            : 'This feature will be available soon',
          style: AppTextStyles.bodyMedium(isArabic: isArabic),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isArabic ? 'حسناً' : 'OK',
              style: AppTextStyles.bodyLarge(isArabic: isArabic)
                  .copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
