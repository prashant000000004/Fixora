import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Structured API exception with status code and parsed message.
class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException({this.statusCode, required this.message});

  @override
  String toString() => message;
}

/// Central HTTP client for communicating with the Spring Boot backend.
/// Includes timeout handling, structured errors, retry logic, and all HTTP methods.
class ApiClient {
  // Override at build time: flutter run --dart-define=API_BASE_URL=http://YOUR_IP:8080/api
  static const String _envUrl = String.fromEnvironment('API_BASE_URL');

  /// Your development machine's LAN IP address.
  /// Find it with: ipconfig (Windows) or ifconfig (Mac/Linux).
  /// Both physical devices and emulators on the same WiFi can reach this.
  static const String _devMachineIp = '192.168.1.36';

  /// Resolve the base URL:
  /// 1. Use API_BASE_URL from --dart-define if provided
  /// 2. Default to the dev machine's LAN IP (works on both emulator & physical device)
  static String get baseUrl {
    if (_envUrl.isNotEmpty) return _envUrl;
    return 'http://$_devMachineIp:8080/api';
  }

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _timeout = Duration(seconds: 15);
  static const _maxRetries = 1;
  static const _retryDelay = Duration(seconds: 1);

  /// Store JWT token securely.
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Get stored JWT token.
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Clear stored token (logout).
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Check if user is logged in.
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Build auth headers.
  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Parse error response body into a readable message.
  static String _parseError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body.containsKey('error')) {
        return body['error'] as String;
      }
      if (body is Map && body.containsKey('message')) {
        return body['message'] as String;
      }
    } catch (_) {}

    switch (response.statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Session expired. Please login again.';
      case 403:
        return 'You don\'t have permission for this action.';
      case 404:
        return 'The requested resource was not found.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong (${response.statusCode}).';
    }
  }

  /// Handle response — throw ApiException on non-2xx status.
  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    throw ApiException(
      statusCode: response.statusCode,
      message: _parseError(response),
    );
  }

  /// Retry wrapper — retries only on network-level failures (SocketException,
  /// TimeoutException), NOT on HTTP errors (ApiException).
  static Future<http.Response> _withRetry(
    Future<http.Response> Function() requestFn,
  ) async {
    debugPrint('[ApiClient] Base URL: $baseUrl');
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        return await requestFn();
      } on SocketException catch (e) {
        debugPrint('[ApiClient] SocketException (attempt $attempt): $e');
        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay);
          continue;
        }
        throw ApiException(
          message: 'No internet connection. Please check your network.',
        );
      } on TimeoutException catch (e) {
        debugPrint('[ApiClient] TimeoutException (attempt $attempt): $e');
        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay);
          continue;
        }
        throw ApiException(message: 'Request timed out. Please try again.');
      } on http.ClientException catch (e) {
        debugPrint('[ApiClient] ClientException (attempt $attempt): $e');
        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay);
          continue;
        }
        throw ApiException(message: 'Connection failed. Please try again.');
      } on ApiException {
        rethrow; // HTTP errors (4xx/5xx) — do NOT retry
      } catch (e) {
        debugPrint(
          '[ApiClient] Unknown error (attempt $attempt): ${e.runtimeType} - $e',
        );
        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay);
          continue;
        }
        throw ApiException(message: 'Something went wrong. Please try again.');
      }
    }
    throw ApiException(message: 'Request failed. Please try again.');
  }

  /// GET request with auth header, error handling, and retry.
  static Future<http.Response> get(String path) async {
    return _withRetry(() async {
      final response = await http
          .get(Uri.parse('$baseUrl$path'), headers: await _headers())
          .timeout(_timeout);
      return _handleResponse(response);
    });
  }

  /// POST request with auth header, error handling, and retry.
  static Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    debugPrint('[ApiClient] POST $baseUrl$path');
    return _withRetry(() async {
      final response = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: await _headers(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    });
  }

  /// PUT request with auth header, error handling, and retry.
  static Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    return _withRetry(() async {
      final response = await http
          .put(
            Uri.parse('$baseUrl$path'),
            headers: await _headers(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    });
  }

  /// DELETE request with auth header, error handling, and retry.
  static Future<http.Response> delete(String path) async {
    return _withRetry(() async {
      final response = await http
          .delete(Uri.parse('$baseUrl$path'), headers: await _headers())
          .timeout(_timeout);
      return _handleResponse(response);
    });
  }
}
