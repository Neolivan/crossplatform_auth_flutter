import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

/// Mixin para exibir notificações toast
mixin ToastShow {
  /// Exibe notificação toast
  static void showToast({
    String title = "",
    String description = "",
    ToastificationType type = ToastificationType.success,
  }) {
    toastification.show(
      title: Text(title),
      type: type,
      autoCloseDuration: const Duration(seconds: 3),
      description: Text(description),
      style: ToastificationStyle.flatColored,
    );
  }
}
