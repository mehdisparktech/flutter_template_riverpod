import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template_riverpod/providers/locale_provider.dart';
import 'package:flutter_template_riverpod/router/app_router.dart';
import 'package:flutter_template_riverpod/theme/src/app_themes.dart';

/// Starting point of our Flutter application
class RiverpodTemplateApp extends StatelessWidget {
  const RiverpodTemplateApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        /// Size of the device the designer uses in their designs on Figma
        designSize: const Size(412, 732),
        builder: (context, child) => Consumer(
          builder: (context, ref, child) {
            final router = ref.watch(appRouterProvider);

            return MaterialApp.router(
              onGenerateTitle: (_) => 'appName'.tr(),
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              theme: AppThemes.primary(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: ref.watch(localeProvider).toLocale(),
            );
          },
        ),
      );
}
