import 'package:get/get.dart';

import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/discussion/bindings/discussion_binding.dart';
import '../modules/discussion/views/discussion_view.dart';
import '../modules/evaluations/bindings/evaluations_binding.dart';
import '../modules/evaluations/views/evaluations_view.dart';
import '../modules/exam/bindings/exam_binding.dart';
import '../modules/exam/views/exam_view.dart';
import '../modules/flash_cards/bindings/flash_cards_binding.dart';
import '../modules/flash_cards/views/flash_cards_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/invitations/bindings/invitations_binding.dart';
import '../modules/invitations/views/invitations_view.dart';
import '../modules/lesson_keys/bindings/lesson_keys_binding.dart';
import '../modules/lesson_keys/views/lesson_keys_view.dart';
import '../modules/policies_and_terms/bindings/policies_and_terms_binding.dart';
import '../modules/policies_and_terms/views/policies_and_terms_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/study_center/bindings/study_center_binding.dart';
import '../modules/study_center/views/study_center_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.DISCUSSION,
      page: () => const DiscussionView(),
      binding: DiscussionBinding(),
    ),
    GetPage(
      name: _Paths.EXAM,
      page: () => const ExamView(),
      binding: ExamBinding(),
    ),
    GetPage(
      name: _Paths.EVALUATIONS,
      page: () => const EvaluationsView(),
      binding: EvaluationsBinding(),
    ),
    GetPage(
      name: _Paths.LESSON_KEYS,
      page: () => const LessonKeysView(),
      binding: LessonKeysBinding(),
    ),
    GetPage(
      name: _Paths.STUDY_CENTER,
      page: () => const StudyCenterView(),
      binding: StudyCenterBinding(),
    ),
    GetPage(
      name: _Paths.FLASH_CARDS,
      page: () => const FlashCardsView(),
      binding: FlashCardsBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.INVITATIONS,
      page: () => const InvitationsView(),
      binding: InvitationsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.POLICIES_AND_TERMS,
      page: () => const PoliciesAndTermsView(),
      binding: PoliciesAndTermsBinding(),
    ),
  ];
}
