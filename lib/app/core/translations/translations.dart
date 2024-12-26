import 'package:get/get.dart';
import 'en_US.dart';
import 'zh_CN.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'zh_CN': zhCN,
      };
}
