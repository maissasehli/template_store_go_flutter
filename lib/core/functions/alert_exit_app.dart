import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/ui.dart';
import 'package:store_go/view/widgets/extensions/buttons/outlined_button.dart';
import 'package:store_go/view/widgets/extensions/buttons/primary_button.dart';
import 'package:store_go/view/widgets/extensions/full_width.dart';
import 'package:store_go/view/widgets/extensions/text_extensions.dart';

Future<bool> alertExitApp(BuildContext context) {
  Get.defaultDialog(
    title: '',
    titlePadding: const EdgeInsets.all(0),
    radius: UIConstants.borderRadiusMedium,
    contentPadding: const EdgeInsets.all(UIConstants.paddingMedium),
    content: SizedBox(
      width: Get.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Exit App').heading4(context),
          const SizedBox(height: UIConstants.marginSmall),
          const Text('Do you want to exit the application?').body(context),
          const SizedBox(height: UIConstants.marginLarge),
          const Text('Cancel')
              .primaryButton(
                context,
                onPressed: () {
                  Get.back();
                },
              )
              .fullWidth(),
          const SizedBox(height: UIConstants.marginSmall),
          const Text('Exit')
              .outlinedButton(
                context,
                onPressed: () {
                  exit(0);
                },
              )
              .fullWidth(),
        ],
      ),
    ),
  );
  return Future.value(true);
}
