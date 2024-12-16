import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:il_env/index.dart';
import '../../../data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  final user = UserModel.clearUser().obs;
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final googleSignIn = GoogleSignIn();
  final firestore = FirebaseFirestore.instance;
  final secureStorage = const FlutterSecureStorage();

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        errorSnackbar(TranslationKey.keyGoogleSignInFailed);
        return;
      }
      isLoading.value = true;
      
      final googleAuth = await googleUser.authentication;
      // if (googleAuth == null) {
      //   errorSnackbar(TranslationKey.keyGoogleAuthFailed);
      //   return;
      // }
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user == null) {
        errorSnackbar(TranslationKey.keyFirebaseSignInFailed);
        return;
      }
      await _getUserData(userCredential.user!.uid, googleUser);
      await secureStorage.write(key: 'userId', value: userCredential.user!.uid);
      isLoggedIn.value = true;
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
      await secureStorage.write(key: 'isLoggedIn', value: 'true');
    } catch (e) {
      errorSnackbar(TranslationKey.keyUnknownError);
      isLoading.value = false;
    }
  }

  Future<void> _getUserData(String userId, GoogleSignInAccount googleAccount) async {
    try {
      final userDoc =
          await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        user.value = UserModel.fromJson(userDoc.data()!);
        await secureStorage.write(key: 'unlimitedAccess', value: user.value.unlimitedAccess.toString()); 
        if (user.value.invitationCount! >= 2) {
          await firestore
              .collection('users')
              .doc(userId)
              .update({'unlimitedAccess': true});
        }
        await secureStorage.write(key: 'invitationCode', value: user.value.invitationCode!);
      } else {
        final newUser = UserModel(
          userId: userId,
          invitationCode: const Uuid().v4(),
          invitedBy: null,
          invitationCount: 0,
          unlimitedAccess: false,
        );
        await firestore
            .collection('users')
            .doc(userId)
            .set(newUser.toJson());
        user.value = newUser;
        await secureStorage.write(key: 'unlimitedAccess', value: 'false');
        await secureStorage.write(key: 'invitationCode', value: newUser.invitationCode!);
      }
    } catch (e) {
      errorSnackbar(TranslationKey.keyFailedToGetUser);
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    isLoggedIn.value = false;
    user.value = UserModel.clearUser();
    await secureStorage.delete(key: 'unlimitedAccess');
    await secureStorage.delete(key: 'invitationCode');
    await secureStorage.delete(key: 'isLoggedIn');
    Get.offAllNamed(Routes.AUTH);
  }

  Future<void> tryAutoLogin() async {
    final isLoggedInValue = await secureStorage.read(key: 'isLoggedIn');
    if (isLoggedInValue == 'true') {
      final userId = await secureStorage.read(key: 'userId');
      if (userId != null) {
        await _getUserData(userId, googleSignIn.currentUser!);
      } else {
        signOut();
      }
      isLoggedIn.value = true;
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }

  Future<void> submitInvitationCode(String invitationCode) async {
    isLoading.value = true;
    if (invitationCode.isEmpty) {
      errorSnackbar(TranslationKey.keyInvitationCodeCannotBeEmpty);
      isLoading.value = false;
      return;
    }
    if (invitationCode == user.value.invitationCode) {
      errorSnackbar(TranslationKey.keyInvitationCodeCannotBeYours);
      isLoading.value = false;
      return;
    }
    final inviteSnapshot = await firestore
        .collection('users')
        .where('invitationCode', isEqualTo: invitationCode)
        .get();
    if (inviteSnapshot.docs.isEmpty) {
      errorSnackbar(TranslationKey.keyInvitationCodeNotFound);
      isLoading.value = false;
      return;
    }
    if (inviteSnapshot.docs.first.id == user.value.userId) {
      errorSnackbar(TranslationKey.keyInvitationCodeCannotBeYours);
      isLoading.value = false;
      return;
    }
    if (user.value.invitedBy != null) {
      errorSnackbar(TranslationKey.keyYouHaveBeenInvited);
      isLoading.value = false;
      return;
    }
    int newInviterCount = 0;
    try {
      newInviterCount = await firestore.runTransaction((transaction) async {
        final invitedUserDoc = await transaction
            .get(firestore.collection('users').doc(user.value.userId));
        if (invitedUserDoc.data()?['invitedBy'] != null) {
          throw translateKeyTr(TranslationKey.keyYouHaveBeenInvited);
        }
        transaction.update(
            firestore.collection('users').doc(user.value.userId),
            {'invitedBy': invitationCode});
        final inviterUserDoc = await transaction
            .get(firestore.collection('users').doc(inviteSnapshot.docs.first.id));
        transaction.update(
            firestore.collection('users').doc(inviteSnapshot.docs.first.id),
            {
              'invitationCount':
                  (inviterUserDoc.data()?['invitationCount'] ?? 0) + 1
            });
        return (inviterUserDoc.data()?['invitationCount'] ?? 0) + 1;
      });
      user.value.invitedBy = invitationCode;
      await _getUserData(user.value.userId!, googleSignIn.currentUser!);
      if (newInviterCount >= 2) {
        await firestore
            .collection('users')
            .doc(inviteSnapshot.docs.first.id)
            .update({'unlimitedAccess': true});
        await secureStorage.write(key: 'unlimitedAccess', value: 'true');
      }
      successSnackbar(TranslationKey.keyInvitationCodeSuccess);
    } catch (e) {
      errorSnackbar(e.toString() == translateKeyTr(TranslationKey.keyYouHaveBeenInvited)
              ? TranslationKey.keyYouHaveBeenInvited
              : TranslationKey.keyUnknownError);
    } finally {
      isLoading.value = false;
    }
  }
}
