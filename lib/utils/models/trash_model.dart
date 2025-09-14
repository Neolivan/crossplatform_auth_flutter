import 'package:crossplatform_auth_flutter/utils/constants/enums/trash_type_enum.dart';
import 'package:geolocator/geolocator.dart';

/// Modelo de dados para pontos de coleta de lixo
class TrashModel {
  /// ID único do ponto de coleta
  final int id;

  /// Posição geográfica do ponto
  final Position position;

  /// Tipo de lixo coletado
  final TrashTypeEnum trashType;

  TrashModel({
    required this.id,
    required this.position,
    required this.trashType,
  });
}
