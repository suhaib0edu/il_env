import 'package:il_env/index.dart';

customSnackbar(
    {required TranslationKey key,
    required TranslationKey key2,
    Color? backgroundColor}) {
  Get.snackbar(
    translateKeyTr(key),
    translateKeyTr(key2),
    backgroundColor: backgroundColor,
  );
}

errorSnackbar(TranslationKey key2) {
  customSnackbar(
    key: TranslationKey.keyError,
    key2: key2,
    backgroundColor: AppColors.tertiaryColor,
  );
}

successSnackbar(TranslationKey key2) {
  customSnackbar(key: TranslationKey.keySuccess, key2: key2);
}
