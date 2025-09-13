import 'dart:convert';

import 'package:crossplatform_auth_flutter/utils/mixins/toast_show/toast_show.dart';
import 'package:crossplatform_auth_flutter/utils/models/user_model.dart';
import 'package:crossplatform_auth_flutter/utils/services/base_request.dart';
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
          title: 'Login realizado com sucesso',
          type: ToastificationType.success,
        );
        var body = jsonDecode(response.body);
        return body['token'];
      } else {
        ToastShow.showToast(
          title: 'Falha ao fazer login',
          description: 'Email ou senha inválidos',
          type: ToastificationType.error,
        );
        return null;
      }
    } catch (e) {
      ToastShow.showToast(
        title: 'Erro de conexão',
        description: 'Verifique sua conexão com a internet',
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
          title: 'Registro realizado com sucesso',
          type: ToastificationType.success,
        );
        var body = jsonDecode(response.body);
        return body;
      } else {
        ToastShow.showToast(
          title: 'Falha ao fazer registro',
          description: 'Verifique as informações e tente novamente',
          type: ToastificationType.error,
        );
        return null;
      }
    } catch (e) {
      ToastShow.showToast(
        title: 'Erro ao fazer registro',
        description: 'Verifique sua conexão com a internet',
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
          title: 'Falha ao buscar informações do usuário',
          type: ToastificationType.error,
        );
        return null;
      }
    } catch (e) {
      ToastShow.showToast(
        title: 'Erro de conexão',
        description: 'Verifique sua conexão com a internet',
        type: ToastificationType.error,
      );
      return null;
    }
  }
}
