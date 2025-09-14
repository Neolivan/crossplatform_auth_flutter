import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:crossplatform_auth_flutter/utils/models/trash_model.dart';
import 'package:crossplatform_auth_flutter/utils/constants/enums/trash_type_enum.dart';

mixin MapLocatorUtils {
  /// Verifica se as permissões de localização estão concedidas
  /// Retorna true se as permissões estão concedidas, false caso contrário
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Obtém a posição atual do dispositivo
  /// Retorna a posição se bem-sucedido, null em caso de erro
  Future<Position?> getCurrentPosition() async {
    try {
      bool hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  /// Gera uma lista mock de TrashModel baseada na localização de referência
  /// [referencePosition] - Posição de referência para gerar os pontos ao redor
  /// [radiusInMeters] - Raio em metros para distribuir os pontos
  /// [quantity] - Quantidade de pontos de lixo a serem gerados
  /// Retorna uma lista de TrashModel com posições aleatórias dentro do raio
  List<TrashModel> mockTrashPositions({
    required Position referencePosition,
    required double radiusInMeters,
    required int quantity,
  }) {
    final List<TrashModel> trashList = [];
    final Random random = Random();
    final List<TrashTypeEnum> trashTypes = TrashTypeEnum.values;

    for (int i = 0; i < quantity; i++) {
      // Gera um ângulo aleatório (0 a 2π)
      double angle = random.nextDouble() * 2 * pi;

      // Gera uma distância aleatória dentro do raio
      double distance = random.nextDouble() * radiusInMeters;

      // Converte metros para graus (aproximação)
      // 1 grau de latitude ≈ 111,320 metros
      // 1 grau de longitude ≈ 111,320 * cos(latitude) metros
      double latOffset = distance / 111320.0;
      double lngOffset =
          distance / (111320.0 * cos(referencePosition.latitude * pi / 180));

      // Calcula a nova posição
      double newLat = referencePosition.latitude + (latOffset * cos(angle));
      double newLng = referencePosition.longitude + (lngOffset * sin(angle));

      // Cria a posição
      Position trashPosition = Position(
        latitude: newLat,
        longitude: newLng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );

      // Seleciona um tipo de lixo aleatório
      TrashTypeEnum randomTrashType =
          trashTypes[random.nextInt(trashTypes.length)];

      // Cria o TrashModel
      trashList.add(
        TrashModel(
          id: random.nextInt(1000000),
          position: trashPosition,
          trashType: randomTrashType,
        ),
      );
    }

    return trashList;
  }
}
