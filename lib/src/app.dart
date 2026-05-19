import 'package:chato/src/imports/core_imports.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final current = _buildMaterialApp(context);
    return ScreenUtilWrapper(child: current);
  }

  Widget _buildMaterialApp(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      title: 'chato',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#154abc'),
      darkTheme: buildDarkTheme(primaryColorHex: '#154abc'),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.onboarding,
      getPages: AppRouter.getPages,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        Widget current = child!;
        current = SkeletonWrapper(child: current);
        current = SessionListenerWrapper(child: current);
        return current;
      },
    );
  }
}