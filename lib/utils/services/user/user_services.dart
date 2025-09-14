import 'dart:convert';

import 'package:crossplatform_auth_flutter/utils/mixins/toast_show/toast_show.dart';
import 'package:crossplatform_auth_flutter/utils/models/user_model.dart';
import 'package:crossplatform_auth_flutter/utils/services/base_request.dart';
import 'package:crossplatform_auth_flutter/utils/constants/enums/labels_enum.dart';
import 'package:toastification/toastification.dart';

mixin UserServices {
  BaseRequest baseRequest = BaseRequest(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': 'reqres-free-v1',
    },
    baseUrl: 'https://reqres.in/api/',
  );

  Future<String?> login(String email, String password) async {
    try {
      final response = await baseRequest.post(
        'login',
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        ToastShow.showToast(
          title: LabelsEnum.loginSuccessService,
          type: ToastificationType.success,
        );
        var body = jsonDecode(response.body);
        return body['token'];
      } else {
        ToastShow.showToast(
          title: LabelsEnum.loginFailed,
          description: LabelsEnum.invalidCredentials,
          type: ToastificationType.error,
        );
        return null;
      }
    } catch (e) {
      ToastShow.showToast(
        title: LabelsEnum.connectionError,
        description: LabelsEnum.checkInternetConnection,
        type: ToastificationType.error,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> register(String email, String password) async {
    try {
      final response = await baseRequest.post(
        'register',
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        ToastShow.showToast(
          title: LabelsEnum.registerSuccess,
          type: ToastificationType.success,
        );
        var body = jsonDecode(response.body);
        return body;
      } else {
        ToastShow.showToast(
          title: LabelsEnum.registerFailed,
          description: LabelsEnum.checkInfoAndTryAgain,
          type: ToastificationType.error,
        );
        return null;
      }
    } catch (e) {
      ToastShow.showToast(
        title: LabelsEnum.registerError,
        description: LabelsEnum.checkInternetConnection,
        type: ToastificationType.error,
      );
      return null;
    }
  }

  Future<UserModel?> getUserInfo(String token) async {
    try {
      final response = await baseRequest.get('users/2');

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return UserModel.fromJson(body['data']);
      } else {
        ToastShow.showToast(
          title: LabelsEnum.getUserInfoFailed,
          type: ToastificationType.error,
        );
        return null;
      }
    } catch (e) {
      ToastShow.showToast(
        title: LabelsEnum.connectionError,
        description: LabelsEnum.checkInternetConnection,
        type: ToastificationType.error,
      );
      return null;
    }
  }

  Future<bool> logoutToken(String? token) async {
    try {
      final response = await baseRequest.post('logout', body: {'token': token});

      if (response.statusCode == 200) {
        ToastShow.showToast(
          title: LabelsEnum.logoutSuccess,
          type: ToastificationType.success,
        );
        return true;
      } else {
        ToastShow.showToast(
          title: LabelsEnum.logoutFailed,
          description: LabelsEnum.checkInternetConnection,
          type: ToastificationType.error,
        );
        return false;
      }
    } catch (e) {
      ToastShow.showToast(
        title: LabelsEnum.connectionError,
        description: LabelsEnum.checkInternetConnection,
        type: ToastificationType.error,
      );
      return false;
    }
  }

  Future<bool> updateUserInfo(UserModel user) async {
    try {
      // final userJson = jsonEncode(user.toJson());
      var mockUpdateJson = {"name": "Teste", "job": "123456"};
      final response = await baseRequest.put('users/2', body: mockUpdateJson);

      if (response.statusCode == 200) {
        ToastShow.showToast(
          title: LabelsEnum.userUpdatedSuccess,
          type: ToastificationType.success,
        );
        return true;
      } else {
        ToastShow.showToast(
          title: LabelsEnum.userUpdateFailed,
          description: LabelsEnum.checkInternetConnection,
          type: ToastificationType.error,
        );
        return false;
      }
    } catch (e) {
      ToastShow.showToast(
        title: LabelsEnum.connectionError,
        description: LabelsEnum.checkInternetConnection,
        type: ToastificationType.error,
      );
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      final response = await baseRequest.delete('users/$id');

      if (response.statusCode == 204) {
        ToastShow.showToast(
          title: LabelsEnum.userDeletedSuccess,
          type: ToastificationType.success,
        );
        return true;
      } else {
        ToastShow.showToast(
          title: LabelsEnum.userDeleteFailed,
          description: LabelsEnum.checkInternetConnection,
          type: ToastificationType.error,
        );
        return false;
      }
    } catch (e) {
      ToastShow.showToast(
        title: LabelsEnum.connectionError,
        description: LabelsEnum.checkInternetConnection,
        type: ToastificationType.error,
      );
      return false;
    }
  }
}
