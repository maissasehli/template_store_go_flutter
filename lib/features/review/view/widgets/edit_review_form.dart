import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class EditReviewForm extends StatelessWidget {
  final Review review;
  final RxInt editRating;
  final TextEditingController editCommentController;
  final FocusNode editCommentFocusNode;
  final RxBool isSubmitting;
  final Function(String) onSubmit;
  final VoidCallback onCancel;

  EditReviewForm({
    super.key,
    required this.review,
    required this.editRating,
    required this.editCommentController,
    required this.editCommentFocusNode,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onCancel,
  });

  final List<String> _quickTags = [
    'Great quality',
    'Good value',
    'Fast shipping',
    'As described',
    'Perfect fit',
    'Highly recommend',
  ];

  @override
  Widget build(BuildContext context) {
    // Request focus when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Short delay to ensure widget is fully rendered
      Future.delayed(const Duration(milliseconds: 100), () {
        if (editCommentFocusNode.canRequestFocus) {
          editCommentFocusNode.requestFocus();
        }
      });
    });

    final bool isRtl = LocalizationService.isRtl(context);

    return Container(
      padding: EdgeInsets.all(UIConfig.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.foreground(context).withAlpha(13), // 0.05 * 255
            blurRadius: UIConfig.elevationLarge,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: UIConfig.paddingSmall),
          _buildRatingSelector(context),
          SizedBox(height: UIConfig.paddingLarge),
          _buildReviewInput(context),
          SizedBox(height: UIConfig.paddingMedium),
          _buildQuickTagsSection(context),
          SizedBox(height: UIConfig.paddingLarge),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'reviews.edit_review'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeMedium,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
        ),
        GestureDetector(
          onTap: onCancel,
          child: Icon(
            Icons.close,
            color: AppColors.mutedForeground(context),
            size: UIConfig.fontSizeLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSelector(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return GestureDetector(
            onTap: () => editRating.value = index + 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIConfig.paddingSmall / 2,
              ),
              child: Icon(
                index < editRating.value
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                size: UIConfig.fontSize2XLarge,
                color:
                    index < editRating.value
                        ? AppColors.accent(context)
                        : AppColors.muted(context),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReviewInput(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return GestureDetector(
      onTap: () {
        if (editCommentFocusNode.canRequestFocus) {
          editCommentFocusNode.requestFocus();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.input(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: TextField(
          controller: editCommentController,
          focusNode: editCommentFocusNode,
          maxLines: 1,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          textInputAction: TextInputAction.newline,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.inputForeground(context),
              fontSize: UIConfig.fontSizeRegular,
              fontFamily: 'Poppins',
            ),
          ),
          decoration: InputDecoration(
            hintText: 'reviews.share_experience'.translate(),
            hintStyle: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.mutedForeground(context),
                fontSize: UIConfig.fontSizeRegular,
                fontFamily: 'Poppins',
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(UIConfig.paddingSmall),
            filled: true,
            fillColor: AppColors.input(context),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTagsSection(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Column(
      crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          'reviews.quick_tags'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeRegular,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
        ),
        SizedBox(height: UIConfig.paddingSmall),
        Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Wrap(
            spacing: UIConfig.paddingSmall,
            runSpacing: UIConfig.paddingSmall,
            children:
                _quickTags.map((tag) => _buildQuickTag(tag, context)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTag(String text, BuildContext context) {
    return GestureDetector(
      onTap: () => _handleQuickTagTap(text),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UIConfig.paddingSmall * 1.5,
          vertical: UIConfig.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusXLarge),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Text(
          text,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeSmall,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: isSubmitting.value ? null : () => _handleSubmit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            foregroundColor: AppColors.primaryForeground(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
            ),
            padding: EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
          ),
          child: _buildButtonContent(context),
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    return isSubmitting.value
        ? SizedBox(
          width: UIConfig.fontSizeLarge,
          height: UIConfig.fontSizeLarge,
          child: CircularProgressIndicator(
            color: AppColors.primaryForeground(context),
          ),
        )
        : Text(
          'reviews.update_review'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeMedium,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        );
  }

  void _handleQuickTagTap(String text) {
    if (editCommentController.text.isEmpty) {
      editCommentController.text = text;
    } else if (!editCommentController.text.endsWith('.')) {
      editCommentController.text += '. $text';
    } else {
      editCommentController.text += ' $text';
    }

    editCommentController.selection = TextSelection.fromPosition(
      TextPosition(offset: editCommentController.text.length),
    );

    if (editCommentFocusNode.canRequestFocus) {
      editCommentFocusNode.requestFocus();
    }
  }

  void _handleSubmit(BuildContext context) {
    if (editRating.value == 0) {
      _showError(context, 'reviews.error_rating'.translate());
      return;
    }

    if (editCommentController.text.trim().isEmpty) {
      _showError(context, 'reviews.error_comment'.translate());
      return;
    }

    onSubmit(review.id);
  }

  void _showError(BuildContext context, String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: AppColors.destructive(context),
      colorText: AppColors.destructiveForeground(context),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(UIConfig.paddingMedium),
    );
  }
}
