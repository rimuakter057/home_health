// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:ezygut/core/service/storage_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/web.dart';
// import '../../utils/app_const/app_const.dart';
// import 'api_url.dart';
//
// class ApiClient {
//
//   // ── GET ───────────────────────────────────────────────
//   static Future<Map<String, dynamic>> get(
//       String endpoint, {
//         Map<String, dynamic>? params,
//       }) async {
//     return _request('GET', endpoint, params: params, requiresAuth: true);
//   }
//
//   // ── POST ──────────────────────────────────────────────
//   static Future<Map<String, dynamic>> post(
//       String endpoint, {
//         Map<String, dynamic>? body,
//         bool requiresAuth = false,
//       }) async
//   {
//     try {
//       final baseUrl = ApiUrl.baseUrl;
//       final headers = <String, String>{
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'x-timezone': DateTime.now().timeZoneName,
//         'x-utc-offset-minutes': DateTime.now().timeZoneOffset.inMinutes.toString(),
//       };
//
//       if (requiresAuth) {
//         final token = await SharePrefsHelper.getString(AppConst.token);
//         if (token != null && token.isNotEmpty) {
//           headers['Authorization'] = 'Bearer $token';
//           Logger().i("🔐 TOKEN ADDED: $token");
//         } else {
//           Logger().e("❌ TOKEN MISSING");
//         }
//       }
//
//       final url = Uri.parse(
//         endpoint.startsWith('http') ? endpoint : '$baseUrl$endpoint',
//       );
//
//       Logger().i("📡 POST URL: $url");
//       Logger().i("📦 POST BODY: ${jsonEncode(body)}");
//
//       final response = await http
//           .post(url, headers: headers, body: jsonEncode(body))
//           .timeout(const Duration(seconds: 30));
//
//       Logger().d("✅ STATUS: ${response.statusCode}");
//       Logger().d("✅ RESPONSE: ${response.body}");
//
//       return jsonDecode(response.body);
//     } catch (e, stackTrace) {
//       Logger().e("💥 ApiClient.post Error", error: e, stackTrace: stackTrace);
//       return {"message": "Something went wrong", "success": false};
//     }
//   }
//
//   // ── PUT ───────────────────────────────────────────────
//   static Future<Map<String, dynamic>> put(
//       String endpoint, {
//         Map<String, dynamic>? body,
//       }) async {
//     return _request('PUT', endpoint, body: body, requiresAuth: true);
//   }
//
//   // ── DELETE ────────────────────────────────────────────
//   static Future<Map<String, dynamic>> delete(String endpoint) async {
//     return _request('DELETE', endpoint, requiresAuth: true);
//   }
//
//   // ── Core Request ──────────────────────────────────────
//   static Future<Map<String, dynamic>> _request(
//       String method,
//       String endpoint, {
//         Map<String, dynamic>? body,
//         Map<String, dynamic>? params,
//         bool requiresAuth = false,
//       }) async
//   {
//     try {
//       // Build URI
//       var uri = Uri.parse('${ApiUrl.baseUrl}$endpoint');
//       if (params != null && params.isNotEmpty) {
//         uri = uri.replace(
//           queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
//         );
//       }
//
//       // Build headers
//       final headers = <String, String>{
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'x-timezone': DateTime.now().timeZoneName,
//         'x-utc-offset-minutes': DateTime.now().timeZoneOffset.inMinutes.toString(),
//       };
//
//       // Attach token if required
//       if (requiresAuth) {
//         final token = await SharePrefsHelper.getString(AppConst.token);
//         if (token.isNotEmpty) {
//           headers['Authorization'] = 'Bearer $token';
//         }
//       }
//
//       // ── Debug: Request ──────────────────────────────
//       debugPrint('');
//       debugPrint('┌─────────────────────────────────────────');
//       debugPrint('│ 🚀 REQUEST');
//       debugPrint('│ $method → $uri');
//       debugPrint('│ Headers: $headers');
//       if (body != null) {
//         debugPrint('│ Body: ${jsonEncode(body)}');
//       }
//       debugPrint('└─────────────────────────────────────────');
//
//       // Make request
//       http.Response response;
//       switch (method) {
//         case 'GET':
//           response = await http
//               .get(uri, headers: headers)
//               .timeout(const Duration(seconds: 30));
//           break;
//         case 'POST':
//           response = await http
//               .post(uri, headers: headers, body: jsonEncode(body))
//               .timeout(const Duration(seconds: 30));
//           break;
//         case 'PUT':
//           response = await http
//               .put(uri, headers: headers, body: jsonEncode(body))
//               .timeout(const Duration(seconds: 30));
//           break;
//         case 'DELETE':
//           response = await http
//               .delete(uri, headers: headers)
//               .timeout(const Duration(seconds: 30));
//           break;
//         default:
//           throw 'Invalid method';
//       }
//
//       // ── Debug: Response ─────────────────────────────
//       final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
//       debugPrint('');
//       debugPrint('┌─────────────────────────────────────────');
//       debugPrint('│ ✅ RESPONSE');
//       debugPrint('│ Status: ${response.statusCode}');
//       debugPrint('│ Body: ${response.body}');
//       debugPrint('└─────────────────────────────────────────');
//
//       return {
//         ...responseBody,
//         'statusCode': response.statusCode,
//       };
//
//     } on SocketException catch (e) {
//       debugPrint('');
//       debugPrint('┌─────────────────────────────────────────');
//       debugPrint('│ ❌ NO INTERNET');
//       debugPrint('│ $e');
//       debugPrint('└─────────────────────────────────────────');
//       return {
//         'success': false,
//         'chat': 'No internet connection.',
//         'statusCode': 0,
//       };
//     } on TimeoutException catch (e) {
//       debugPrint('');
//       debugPrint('┌─────────────────────────────────────────');
//       debugPrint('│ ⏱ TIMEOUT');
//       debugPrint('│ $e');
//       debugPrint('└─────────────────────────────────────────');
//       return {
//         'success': false,
//         'chat': 'Request timeout. Please try again.',
//         'statusCode': 0,
//       };
//     } catch (e) {
//       debugPrint('');
//       debugPrint('┌─────────────────────────────────────────');
//       debugPrint('│ 💥 ERROR');
//       debugPrint('│ $e');
//       debugPrint('└─────────────────────────────────────────');
//       return {
//         'success': false,
//         'chat': 'Something went wrong.',
//         'statusCode': 0,
//       };
//     }
//   }
// }
//
//







import 'dart:convert';

import 'package:ezygut/core/service/storage_service.dart';

import '../../utils/app_const/app_const.dart';
import '../network/exceptions/api_exception.dart';
import '../network/handlers/error_handler.dart';
import '../network/interceptors/network_logger.dart';
import 'api_url.dart';


import 'package:http/http.dart' as http;

class ApiClient {
  // ── GET ───────────────────────────────────────────────
  static Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? params,
      }) async {
    return _request('GET', endpoint, params: params, requiresAuth: true);
  }

  // ── POST ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? body,
        bool requiresAuth = false,
      }) async {
    return _request('POST', endpoint, body: body, requiresAuth: requiresAuth);
  }

  // ── PUT ───────────────────────────────────────────────
  static Future<Map<String, dynamic>> put(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    return _request('PUT', endpoint, body: body, requiresAuth: true);
  }

  // ── DELETE ────────────────────────────────────────────
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    return _request('DELETE', endpoint, requiresAuth: true);
  }

  // ── Core Request ──────────────────────────────────────
  static Future<Map<String, dynamic>> _request(
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, dynamic>? params,
        bool requiresAuth = false,
      }) async {
    var uri = Uri.parse('${ApiUrl.baseUrl}$endpoint');

    try {
      if (params != null && params.isNotEmpty) {
        uri = uri.replace(
          queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
        );
      }

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-timezone': DateTime.now().timeZoneName,
        'x-utc-offset-minutes': DateTime.now().timeZoneOffset.inMinutes.toString(),
      };

      if (requiresAuth) {
        final token = await SharePrefsHelper.getString(AppConst.token);
        if (token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      NetworkLogger.logRequest(method: method, url: uri.toString(), headers: headers, body: body);

      http.Response response;
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 30));
          break;
        case 'POST':
          response = await http
              .post(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
          break;
        case 'PUT':
          response = await http
              .put(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers).timeout(const Duration(seconds: 30));
          break;
        default:
          throw ApiException(message: 'Invalid HTTP method: $method');
      }

      // ⚠️ আগে এখানে সরাসরি jsonDecode করা হতো এবং body খালি বা non-JSON
      // (যেমন server 502/HTML error page) হলে exception উঠে গিয়ে আসল
      // statusCode হারিয়ে গিয়ে সবসময় statusCode: 0 রিটার্ন হতো।
      // এখন সেটা নিরাপদভাবে handle করা হচ্ছে, আসল statusCode বজায় থাকে।
      dynamic decoded;
      try {
        decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      } catch (_) {
        decoded = {'raw': response.body};
      }

      NetworkLogger.logResponse(url: uri.toString(), statusCode: response.statusCode, body: decoded);

      final apiResponse = ErrorHandler.fromStatusCode(response.statusCode, decoded, response.reasonPhrase);

      if (!apiResponse.isSuccess) {
        final Map<String, dynamic> errorBody = decoded is Map<String, dynamic> ? decoded : {};
        return {
          ...errorBody,
          'success': false,
          // ✅ মূল fix: এখন generic "Something went wrong" এর বদলে
          // proper, নির্দিষ্ট message আসবে (server message > status-based message)
          'message': apiResponse.message,
          'chat': apiResponse.message,
          'statusCode': response.statusCode,
        };
      }

      final Map<String, dynamic> successBody =
      decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      return {
        ...successBody,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      final apiResponse = ErrorHandler.handle(e, uri.toString(), method);
      return {
        'success': false,
        'message': apiResponse.message,
        'chat': apiResponse.message,
        'statusCode': apiResponse.statusCode ?? 0,
      };
    }
  }
}
