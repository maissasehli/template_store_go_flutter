import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class DraggableInfoSheet extends StatelessWidget {
  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool showDragHandle;

  const DraggableInfoSheet({
    super.key,
    required this.child,
    this.initialChildSize = 0.42,
    this.minChildSize = 0.42,
    this.maxChildSize = 0.8,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(UIConfig.borderRadius3XLarge),
              topRight: Radius.circular(UIConfig.borderRadius3XLarge),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.foreground(context).withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragHandle) _buildDragHandle(context),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(UIConfig.paddingLarge),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: UIConfig.paddingMedium,
        bottom: UIConfig.paddingSmall,
      ),
      child: Center(
        child: Container(
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.muted(context),
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          ),
        ),
      ),
    );
  }
}

/// An alternative version with built-in header
class DraggableInfoSheetWithHeader extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const DraggableInfoSheetWithHeader({
    super.key,
    required this.child,
    required this.title,
    this.leading,
    this.trailing,
    this.initialChildSize = 0.42,
    this.minChildSize = 0.42,
    this.maxChildSize = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(UIConfig.borderRadius3XLarge),
              topRight: Radius.circular(UIConfig.borderRadius3XLarge),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.foreground(context).withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(context),
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(UIConfig.paddingLarge),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: UIConfig.paddingMedium, 
        bottom: UIConfig.paddingSmall,
      ),
      child: Center(
        child: Container(
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.muted(context),
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConfig.paddingLarge,
        vertical: UIConfig.paddingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null) leading!,
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: leading != null ? TextAlign.start : TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) 
            trailing!
          else 
            const SizedBox(width: 24), // For balanced spacing when no trailing widget
        ],
      ),
    );
  }
}