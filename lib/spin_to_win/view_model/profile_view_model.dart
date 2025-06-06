import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/repo/profile_repo.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';
import 'package:super_star/utils/routes/routes_name.dart';

class ProfileViewModel with ChangeNotifier {
  final _profileRepo = ProfileRepository();
  dynamic _balance = 0;

  dynamic get balance => _balance;

  void addBalance(dynamic amount) {
    _balance += amount;
    notifyListeners();
  }

  void deductBalance(dynamic amount) {
    _balance -= amount;
    notifyListeners();
  }

  void setBalance(dynamic amount) {
    _balance = amount;
    notifyListeners();
  }

  String _userName = '';

  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  Future<void> profileApi(context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    String? deviceId = await UserViewModel.getDeviceId();
    _profileRepo
        .profileApi(userId)
        .then((value) {
          if (value.success == true) {
            Provider.of<ProfileViewModel>(
              context,
              listen: false,
            ).setUserName('${value.data?.username}');
            Provider.of<ProfileViewModel>(
              context,
              listen: false,
            ).setBalance(value.data?.wallet ?? 0);
            if (value.data!.status.toString() == '0') {
              showSessionExpiredDialog(
                context,
                title: "User Blocked",
                content:
                    "The user has been blocked by admin.\nplease contact with admin to continue.",
              );
              return;
            }
            if (value.data!.deviceId.toString() != deviceId) {
              showSessionExpiredDialog(context);
            }
          } else {
            if (kDebugMode) {
              print('value: ${value.message}');
            }
          }
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print('error: $error');
          }
        });
  }

  Future<void> showSessionExpiredDialog(
    BuildContext context, {
    String? content,
    title,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
              const SizedBox(width: 10),
              Text(
                title ?? 'Session Expired',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            content ??
                'Someone else has logged in with your username and password.\nPlease login again to continue.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                UserViewModel().remove();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(RoutesName.login, (context) => false);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
