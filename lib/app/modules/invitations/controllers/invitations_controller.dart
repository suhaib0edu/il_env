import 'dart:math';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvitationsController extends GetxController {
  final supabase = Supabase.instance.client;
  RxString invitationCode = "".obs;
  RxString inviterCode = "".obs;
  RxBool unlimitedAccess = false.obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isDataLoading.value = true;
      await getUserInvitationData();
      await createUserInvitationData();
      await checkUnlimitedAccess();
    } catch (e) {
      print("Error loading initial data: $e");
    } finally {
      isDataLoading.value = false;
    }
  }

  // الدالة لإنشاء رمز دعوة عشوائي
  String generateRandomCode(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final code = String.fromCharCodes(
      List.generate(
        length,
        (index) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    return code;
  }

  // دالة لإنشاء بيانات دعوة للمستخدم إذا لم تكن موجودة
  Future<void> createUserInvitationData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        print("User not logged in");
        return;
      }

      // التحقق من وجود بيانات الدعوة للمستخدم
      final existingData = await supabase
          .from('invitations')
          .select('id')
          .eq('userid', userId)
          .maybeSingle();

      if (existingData == null) {
        // إذا لم تكن البيانات موجودة، قم بإنشائها
        final newInvitationCode = generateRandomCode(8);
        await supabase.from('invitations').insert({
          'userid': userId,
          'invitationcode': newInvitationCode,
        });
        invitationCode.value = newInvitationCode;
        print("User invitation data created successfully.");
      } else {
        print("User invitation data already exists");
      }
    } catch (e) {
      print("Error creating user invitation data: $e");
    }
  }

  // دالة لإضافة رمز الداعي
  Future<void> addInviterCode(String inviterCode) async {
  try {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in");
      return;
    }
    final userInvitationData = await supabase
        .from('invitations')
        .select('invitationcode, invitedby')
        .eq('userid', userId)
        .maybeSingle();

    if (userInvitationData?['invitedby'] != null) {
      print("Inviter code already exists");
      return;
    }
    final currentUserInvitationCode = userInvitationData?['invitationcode'];

    if (currentUserInvitationCode == inviterCode) {
      print("Cannot invite yourself");
      return;
    }
    final isCodeValid = await supabase
        .from('invitations')
        .select('id')
        .eq('invitationcode', inviterCode)
        .maybeSingle();

    if (isCodeValid == null) {
      print("Invalid inviter code");
      return;
    }
    await supabase.from('invitations').update({
      'invitedby': inviterCode,
    }).eq('userid', userId);
    this.inviterCode.value = inviterCode;
    print("Inviter code added successfully.");
  } catch (e) {
    print("Error adding inviter code: $e");
  }
}

  // دالة للتحقق من حالة الوصول غير المحدود
  Future<void> checkUnlimitedAccess() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        print("User not logged in");
        return;
      }
      final userInvitationData = await supabase
          .from('invitations')
          .select('invitationcode, unlimited_access')
          .eq('userid', userId)
          .maybeSingle();

      if (userInvitationData == null) {
        print("User invitation data not found");
        return;
      }

      final invitationCode = userInvitationData['invitationcode'] as String;
      final unlimited_access = userInvitationData['unlimited_access'] as bool;

      if (unlimited_access) {
        unlimitedAccess.value = unlimited_access;
        return;
      }

      final invitedUsersCount = await supabase
          .from('invitations')
          .select('id')
          .eq('invitedby', invitationCode)
          .count();

      if (invitedUsersCount.count > 1) {
        await supabase
            .from('invitations')
            .update({'unlimited_access': true}).eq('userid', userId);
        unlimitedAccess.value = true;
      }
    } catch (e) {
      print("Error checking unlimited access: $e");
    }
  }

  // دالة للحصول على بيانات الدعوة الخاصة بالمستخدم
  Future<void> getUserInvitationData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        print("User not logged in");
        return;
      }

      final userData = await supabase
          .from('invitations')
          .select('invitationcode, invitedby, unlimited_access')
          .eq('userid', userId)
          .maybeSingle();
      if (userData != null) {
        invitationCode.value = userData['invitationcode'] ?? '';
        inviterCode.value = userData['invitedby'] ?? '';
        unlimitedAccess.value = userData['unlimited_access'] ?? false;
      } else {
        invitationCode.value = '';
        inviterCode.value = '';
        unlimitedAccess.value = false;
      }
    } catch (e) {
      print("Error getting user invitation data: $e");
    }
  }
}
