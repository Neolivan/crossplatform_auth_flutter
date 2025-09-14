import 'dart:convert';

import 'package:crossplatform_auth_flutter/utils/constants/enums/labels_enum.dart';
import 'package:crossplatform_auth_flutter/utils/mixins/toast_show/toast_show.dart';
import 'package:crossplatform_auth_flutter/utils/services/base_request.dart';
import 'package:latlong2/latlong.dart';
import 'package:toastification/toastification.dart';

mixin MapRoutesService {
  BaseRequest baseRequest = BaseRequest(
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    baseUrl: 'https://router.project-osrm.org/route/v1/',
  );

  /// Gera uma rota entre dois pontos usando a API OSRM
  /// Retorna uma lista de coordenadas LatLng que formam a rota
  Future<List<LatLng>> getRoute(
    LatLng start,
    LatLng end, {
    String profile = 'walking', // driving, walking, cycling
  }) async {
    try {
      final url =
          '$profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

      final response = await baseRequest.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];

          if (geometry['type'] == 'LineString' &&
              geometry['coordinates'] != null) {
            final coordinates = geometry['coordinates'] as List;
            return coordinates.map((coord) {
              // GeoJSON usa [longitude, latitude], mas LatLng usa (latitude, longitude)
              return LatLng(coord[1].toDouble(), coord[0].toDouble());
            }).toList();
          }
        }
      }

      ToastShow.showToast(
        title: '${LabelsEnum.routeFailure}: ${response.statusCode}',
        type: ToastificationType.error,
      );
      return [];
    } catch (e) {
      ToastShow.showToast(
        title: '${LabelsEnum.osrmConnectionError}: $e',
        type: ToastificationType.error,
      );
      return [];
    }
  }

  /// Gera uma rota com múltiplos waypoints
  Future<List<LatLng>> getRouteWithWaypoints(
    List<LatLng> waypoints, {
    String profile = 'walking', // driving, walking, cycling
  }) async {
    if (waypoints.length < 2) {
      ToastShow.showToast(
        title: LabelsEnum.needAtLeastTwoWaypoints,
        type: ToastificationType.error,
      );
    }

    try {
      final waypointsString = waypoints
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');

      final url = '$profile/$waypointsString?overview=full&geometries=geojson';

      final response = await baseRequest.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];

          if (geometry['type'] == 'LineString' &&
              geometry['coordinates'] != null) {
            final coordinates = geometry['coordinates'] as List;
            return coordinates.map((coord) {
              return LatLng(coord[1].toDouble(), coord[0].toDouble());
            }).toList();
          }
        }
      }

      ToastShow.showToast(
        title: '${LabelsEnum.routeFailure}: ${response.statusCode}',
        type: ToastificationType.error,
      );
      return [];
    } catch (e) {
      ToastShow.showToast(
        title: '${LabelsEnum.osrmConnectionError}: $e',
        type: ToastificationType.error,
      );
      return [];
    }
  }
}
