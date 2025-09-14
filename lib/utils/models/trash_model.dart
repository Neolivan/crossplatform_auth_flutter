import 'package:crossplatform_auth_flutter/utils/constants/enums/trash_type_enum.dart';
import 'package:geolocator/geolocator.dart';

class TrashModel {
  final int id;
  final Position position;
  final TrashTypeEnum trashType;

  TrashModel({
    required this.id,
    required this.position,
    required this.trashType,
  });
}
