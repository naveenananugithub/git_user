import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/user.dart';

class GitHubProvider with ChangeNotifier {
  List<GitHubUser> _users = [];
  bool _isLoading = false;
  bool _hasError = false;

  List<GitHubUser> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> searchUsers(String username, {required String token}) async {
    final searchUrl =
        Uri.parse('https://api.github.com/search/users?q=$username');
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final response = await http.get(
        searchUrl,
        headers: {'Authorization': 'token $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List usersData = data['items'];

        _users = await Future.wait(usersData.map((userData) async {
          print("kkakakakak ${userData['url']}");
          final userDetailResponse = await http.get(
            Uri.parse(userData['url']),
            headers: {'Authorization': 'token $token'},
          );

          if (userDetailResponse.statusCode == 200) {
            final userDetails = json.decode(userDetailResponse.body);
            // print("dhdhdhdhdhhdhdd $userDetails");
            return GitHubUser.fromJson(userDetails);
          } else {
            // print(
            //     'Error fetching user details: ${userDetailResponse.statusCode}');
            return GitHubUser(
              login: userData['login'],
              avatarUrl: userData['avatar_url'],
              publicRepos: 0,
            );
          }
        }).toList());
      } else {
        _hasError = true;
      }
    } catch (e) {
      print('Error: $e');
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUsers() {
    _users = [];
    notifyListeners();
  }
}
