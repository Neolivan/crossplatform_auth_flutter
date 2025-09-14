import 'package:flutter/material.dart';
import 'package:crossplatform_auth_flutter/utils/constants/enums/labels_enum.dart';

/// Tela de página não encontrada
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(LabelsEnum.pageNotFound)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              LabelsEnum.error404,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(LabelsEnum.pageNotFound, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
