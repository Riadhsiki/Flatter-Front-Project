import 'package:fluttertesttest/models/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AuthService {
  Future<bool> login(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(password);
    print("ba3ed pss");
    print(username);
    print("ba3ed usr");
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:8081/realms/BWS/protocol/openid-connect/token'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
          'client_id': 'BWS',
          'grant_type': 'password',
          'client_secret': 'wfd2Q6MUaC6fVexptviOQHxiw0dQPR0p',
        },
      );
      print('response');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String accessToken = data['access_token'];
        String refreshToken = data['refresh_token'];
        // Store the access token in shared preferences
        prefs.setString('access_token', accessToken);
        prefs.setString('refresh_token', refreshToken);
        print(prefs.getString('refresh_token'));
        // Navigation to the next page after successful login
        return true; // Successful login
      } else {
        return false; // Login failed
      }
    } catch (e) {
      print(e);
      // Handle connection errors
      return false; // Login failed
    }
  }
  UserInfo parseUserInfo(String jsonData) {
    final Map<String, dynamic> data = json.decode(jsonData);
    return UserInfo.fromJson(data);
  }
  Future<UserInfo?> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse(
          'http://localhost:8081/realms/BWS/protocol/openid-connect/userinfo'),
          
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response);
    if (response.statusCode == 200) {
      return UserInfo.fromJson(
          json.decode(response.body)); // Convertissez la réponse en JSON
    } else {
      throw Exception('Failed to fetch user info');
    }
  }
  Future<bool> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');
    print("refreshToken");
    print(refreshToken);
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:8081/realms/BWS/protocol/openid-connect/logout'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': 'PFE',
          'refresh_token': '$refreshToken',
          'client_secret': 'wfd2Q6MUaC6fVexptviOQHxiw0dQPR0p',
        },
      );
      if (response.statusCode == 200) {
        // ignore: unused_local_variable
        Map<String, dynamic> data = json.decode(response.body);
        // Store the access token in shared preferences
        prefs.clear();
        // Navigation to the next page after successful login
        return true; // Successful login
      } else {
        return false; // Login failed
      }
    } catch (e) {
      print(e);
      // Handle connection errors
      return false; // Login failed
    }
  }
}

