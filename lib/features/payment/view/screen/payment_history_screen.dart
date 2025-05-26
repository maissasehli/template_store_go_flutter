import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import '../../controller/payment_controller.dart';
import '../../models/payment_history_model.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final PaymentController _paymentController = Get.find<PaymentController>();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _paymentController.fetchPaymentHistory();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreHistory();
    }
  }

  Future<void> _loadMoreHistory() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    await _paymentController.fetchPaymentHistory(page: _currentPage);

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: isRtl ? 0 : 16, right: isRtl ? 16 : 0),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.secondary(context),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: ThemeAwareSvg(
              assetPath: isRtl ? AssetConfig.arrowRight : AssetConfig.arrowLeft,
              height: 24,
              width: 24,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          'payment.payment_history'.tr,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _paymentController.fetchPaymentHistory(),
        color: AppColors.primary(context),
        child: Obx(() {
          if (_paymentController.isLoadingHistory.value &&
              _paymentController.paymentHistory.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary(context),
              ),
            );
          }

          if (_paymentController.hasError.value) {
            return _buildErrorView();
          }

          if (_paymentController.paymentHistory.isEmpty) {
            return _buildEmptyState();
          }

          return _buildHistoryList();
        }),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(UIConfig.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.destructive(context),
            ),
            SizedBox(height: UIConfig.marginMedium),
            Text(
              'payment.error_loading_history'.tr,
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.foreground(context),
                  fontSize: UIConfig.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UIConfig.marginSmall),
            Text(
              _paymentController.errorMessage.value,
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.mutedForeground(context),
                  fontSize: UIConfig.fontSizeMedium,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UIConfig.marginLarge),
            ElevatedButton(
              onPressed: () {
                _currentPage = 1;
                _paymentController.fetchPaymentHistory();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: AppColors.primaryForeground(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
              ),
              child: Text('common.retry'.tr).button(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(UIConfig.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.muted(context),
            ),
            SizedBox(height: UIConfig.marginMedium),
            Text(
              'payment.no_payment_history'.tr,
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.foreground(context),
                  fontSize: UIConfig.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UIConfig.marginSmall),
            Text(
              'payment.no_payment_history_desc'.tr,
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.mutedForeground(context),
                  fontSize: UIConfig.fontSizeMedium,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      itemCount:
          _paymentController.paymentHistory.length + (_isLoadingMore ? 1 : 0),
      separatorBuilder:
          (context, index) => SizedBox(height: UIConfig.marginSmall),
      itemBuilder: (context, index) {
        if (index == _paymentController.paymentHistory.length) {
          return _buildLoadingItem();
        }

        final payment = _paymentController.paymentHistory[index];
        return _buildPaymentHistoryCard(payment);
      },
    );
  }

  Widget _buildLoadingItem() {
    return Container(
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary(context),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryCard(PaymentHistory payment) {
    return Container(
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with order ID and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'payment.order_id'.tr.replaceFirst('{id}', payment.orderId),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      color: AppColors.foreground(context),
                      fontSize: UIConfig.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildStatusChip(payment),
            ],
          ),

          SizedBox(height: UIConfig.marginSmall),

          // Amount and payment method
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                payment.formattedAmount,
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    color: AppColors.foreground(context),
                    fontSize: UIConfig.fontSizeLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _getPaymentMethodDisplay(payment.paymentMethod),
                style: LocalizationService.getLocalizedTextStyle(
                  context,
                  TextStyle(
                    color: AppColors.mutedForeground(context),
                    fontSize: UIConfig.fontSizeSmall,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: UIConfig.marginSmall),

          // Date and description
          Text(
            _formatDate(payment.createdAt),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.mutedForeground(context),
                fontSize: UIConfig.fontSizeSmall,
              ),
            ),
          ),

          if (payment.description != null) ...[
            SizedBox(height: 4),
            Text(
              payment.description!,
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.mutedForeground(context),
                  fontSize: UIConfig.fontSizeSmall,
                ),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Receipt link if available
          if (payment.receiptUrl != null) ...[
            SizedBox(height: UIConfig.marginSmall),
            GestureDetector(
              onTap: () => _openReceipt(payment.receiptUrl!),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_outlined,
                    size: 16,
                    color: AppColors.primary(context),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'payment.view_receipt'.tr,
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        color: AppColors.primary(context),
                        fontSize: UIConfig.fontSizeSmall,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(PaymentHistory payment) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    if (payment.isSuccessful) {
      backgroundColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
      statusText = 'payment.status.success'.tr;
    } else if (payment.isPending) {
      backgroundColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange;
      statusText = 'payment.status.pending'.tr;
    } else {
      backgroundColor = Colors.red.withOpacity(0.1);
      textColor = Colors.red;
      statusText = 'payment.status.failed'.tr;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UIConfig.paddingSmall,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
      ),
      child: Text(
        statusText,
        style: LocalizationService.getLocalizedTextStyle(
          context,
          TextStyle(
            color: textColor,
            fontSize: UIConfig.fontSizeSmall - 1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _getPaymentMethodDisplay(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'credit_card':
      case 'card':
        return 'payment.method.credit_card'.tr;
      case 'debit_card':
        return 'payment.method.debit_card'.tr;
      case 'paypal':
        return 'payment.method.paypal'.tr;
      case 'apple_pay':
        return 'payment.method.apple_pay'.tr;
      case 'google_pay':
        return 'payment.method.google_pay'.tr;
      default:
        return paymentMethod.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'common.today'.tr + ' ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'common.yesterday'.tr + ' ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${'common.days_ago'.tr}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _openReceipt(String receiptUrl) {
    // Navigate to receipt view or open in browser
    // For now, just show a snackbar
    Get.snackbar(
      'payment.receipt'.tr,
      'payment.receipt_opening'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary(context),
      colorText: AppColors.primaryForeground(context),
    );
  }
}
