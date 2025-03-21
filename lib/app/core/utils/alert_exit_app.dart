import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/extensions/buttons/outlined_button.dart';
import 'package:store_go/app/shared/extensions/buttons/primary_button.dart';
import 'package:store_go/app/shared/extensions/full_width_extension.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';

Future<bool> alertExitApp(BuildContext context) {
  Get.defaultDialog(
    title: '',
    titlePadding: const EdgeInsets.all(0),
    radius: UIConfig.borderRadiusMedium,
    contentPadding: const EdgeInsets.all(UIConfig.paddingMedium),
    content: SizedBox(
      width: Get.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Exit App').heading4(context),
          const SizedBox(height: UIConfig.marginSmall),
          const Text('Do you want to exit the application?').body(context),
          const SizedBox(height: UIConfig.marginLarge),
          const Text('Cancel')
              .primaryButton(
                context,
                onPressed: () {
                  Get.back();
                },
              )
              .fullWidth(),
          const SizedBox(height: UIConfig.marginSmall),
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
