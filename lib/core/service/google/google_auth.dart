import 'dart:convert';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/core/service/socket_service.dart';
import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';




// I/flutter (13760): 📡 Status: 200
// I/flutter (13760): 📨 Body: {"success":true,"statusCode":200,
// "message":"Google authentication successful","data":
// {"token":""3Nzc1MTg5NTksImV4cCI6MTc3ODEyMzc1OX","user":{"_id":"69ec60cfa14d34eef8171aed",
// "name":"Durjoy","email":"ffggggggffffcfffcfc@gmail.com","role":"patient",
// "authProvider":"google","googleId":"104189439986804611306","isVerified":true,
// "isActive":true,"rememberMe":false,"profilePicture":null,
// "patientProfile":
// {"gender":"Female","age":19,"sleepAvg":6,"weight":28,
// "isEliminationStage":true,"foodSensitivities":["Other","Caffeine"],
// "symptoms":["Constipation","Diarrhea"]},"isDeleted":false,"deletedAt":null,
// "createdAt":"2026-04-25T06:35:59.871Z","updatedAt":"2026-04-25T06:36:14.426Z","__v":0},
// "isNewUser":false,"needsOnboarding":false}}
// I/flutter (13760): ✅ Token & user data saved | role: patient




// ─────────────────────────────────────────────────────────────────────────────
// EXCEPTION
// ─────────────────────────────────────────────────────────────────────────────

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// GOOGLE AUTH SERVICE
// ─────────────────────────────────────────────────────────────────────────────

class GoogleAuthService {





///sign up with google====================================================

  static Future<Map<String, dynamic>> signUpWithGoogle({
    required String role,
  }) async
  {


    try {
      await GoogleSignIn.instance.signOut();

      final GoogleSignInAccount googleUser =
      await GoogleSignIn.instance.authenticate();

      debugPrint('👤 Google user: ${googleUser.email}');

      final auth = await googleUser.authentication;
      final idToken = auth.idToken;

      if (idToken == null) throw Exception('Google ID token পাওয়া যায়নি');

      final requestBody = {'idToken': idToken, 'role': role};

      final response = await http.post(
        Uri.parse(ApiUrl.googleLogin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('📡 Status Code: ${response.statusCode}');
      debugPrint('📨 Response Body: ${response.body}');

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      // ✅ Status Code Handle — শুধু 200/201 accept
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('❌ Status ${response.statusCode} → ApiException throw হচ্ছে');
        throw ApiException(
          message: body['message'] ?? 'Something went wrong',
          statusCode: response.statusCode,
        );
      }

      // ✅ Data বের করো
      final token = body['data']['token'];
      final user = body['data']['user'] as Map<String, dynamic>;
      final returnedRole = user['role'] as String? ?? '';

      // ✅ Token + User + Role সেভ করো
      debugPrint('💾 SharedPrefs এ সেভ করা হচ্ছে...');
      await SharePrefsHelper.setString(AppConst.token, token);
      await SharePrefsHelper.setString(AppConst.userData, jsonEncode(user));
      await SharePrefsHelper.setString(AppConst.selectedRole, returnedRole); // ✅ role আলাদা সেভ
      debugPrint('✅ Token সেভ: $token');
      debugPrint('✅ Role সেভ: $returnedRole');

      // ✅ Result তৈরি করো
      final result = <String, dynamic>{
        'token': token,
        'user': user,
        'statusCode': response.statusCode, // ✅ status code পাঠাও
        'needsOnboarding': body['data']['needsOnboarding'] ?? false,
        'isNewUser': body['data']['isNewUser'] ?? false,
      };

      debugPrint('─────────────────────────────────');
      debugPrint('📊 FINAL RESULT:');
      debugPrint('   token: $token');
      debugPrint('   email: ${user['email']}');
      debugPrint('   role: $returnedRole');
      debugPrint('   statusCode: ${response.statusCode}');
      debugPrint('   isNewUser: ${result['isNewUser']}');
      debugPrint('   needsOnboarding: ${result['needsOnboarding']}');
      debugPrint('─────────────────────────────────');

      return result;
    } catch (e) {
      debugPrint('🔥 Google Sign-In Error: $e');
      rethrow;
    }
  }



  ///sign  with google====================================================

  static Future<Map<String, dynamic>> signInWithGoogle({
    required String role,
  }) async
  {
    debugPrint('🚀 Google Sign-In started | role: $role');

    try {
      await GoogleSignIn.instance.signOut();

      final GoogleSignInAccount googleUser =
      await GoogleSignIn.instance.authenticate();

      debugPrint('👤 Google user: ${googleUser.email}');

      final auth = await googleUser.authentication;
      final idToken = auth.idToken;

      if (idToken == null) throw Exception('Failed to get Google ID token');

      debugPrint('🔑 ID Token received');

      final response = await http.post(
        Uri.parse(ApiUrl.googleLogin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken, 'role': role}),
      );

      debugPrint('📡 Status: ${response.statusCode}');
      debugPrint('📨 Body: ${response.body}');

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          message: body['message'] ?? 'Something went wrong',
          statusCode: response.statusCode,
        );
      }

      final token = body['data']['token'] as String?;
      if (token == null) throw Exception('Token not found in response');
      final user = body['data']['user'] as Map<String, dynamic>;
      final selectedRole = user['role'] as String? ?? '';
      final needsOnboarding = body['data']['needsOnboarding'] as bool? ?? false;
      final userId = body['data']['user'] ['_id']?? '';

      await Future.wait([
        SharePrefsHelper.setString(AppConst.token, token),
        SharePrefsHelper.setString(AppConst.userData, jsonEncode(user)),
        SharePrefsHelper.setString(AppConst.selectedRole, selectedRole),
        SharePrefsHelper.setString(AppConst.userId, userId),
      ]);
      await AppSocket.syncUserSession();

      debugPrint('✅ Token & user data saved | role: $selectedRole');

      return {
        'token': token,
        'user': user,
        'needsOnboarding': needsOnboarding,
      };
    } catch (e) {
      debugPrint('🔥 Google Sign-In error: $e');
      rethrow;
    }
  }











}