import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/constant/app_constant.dart';
import 'app_exception.dart';

class ApiHelper {
  getAPI() {}

  Future<dynamic> postAPI({
    required String url,
    Map<String, dynamic>? mBodyParams,
    Map<String, String>? mHeaders,
    bool isAuth = false,
  }) async {
    if (!isAuth) {
      mHeaders ??= {};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(AppConstants.PREF_USER_TOKEN) ?? "";
      mHeaders["Authorization"] = "Bearer $token";
    }


    try {
      http.Response response = await http.post(
          Uri.parse(url),
          body: mBodyParams != null ? jsonEncode(mBodyParams) : null,
          headers: mHeaders
      );
      return handleResponse(res: response);
    } on SocketException catch (e) {
      throw NoInternetException(exceptionMsg: e.toString());
    } catch (e) {
      rethrow;
    }
  }

  dynamic handleResponse({required http.Response res}) {
    switch (res.statusCode) {
      case 200:
        {
          ///success
          var data = jsonDecode(res.body);
          return data;
        }

      case 400:
        {
          throw BadRequestException(
            exceptionMsg: "with status code ${res.statusCode}",
          );
        }

      case 401:
        {
          throw UnAuthorisedException(
            exceptionMsg: "with status code ${res.statusCode}",
          );
        }

      case 404:
        {
          throw NoInternetException(
            exceptionMsg: "with status code ${res.statusCode}",
          );
        }

      case 500:
      default:
        {
          throw ServerException(
            exceptionMsg: "with status code ${res.statusCode}",
          );
        }
    }
  }
}