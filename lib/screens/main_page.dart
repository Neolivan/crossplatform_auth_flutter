import 'dart:async';
import 'package:crossplatform_auth_flutter/utils/constants/enums/labels_enum.dart';
import 'package:crossplatform_auth_flutter/utils/constants/enums/trash_type_enum.dart';
import 'package:crossplatform_auth_flutter/utils/global_states/user_provider.dart';
import 'package:crossplatform_auth_flutter/utils/mixins/map_locator_utils/map_locator_utils.dart';
import 'package:crossplatform_auth_flutter/utils/mixins/toast_show/toast_show.dart';
import 'package:crossplatform_auth_flutter/utils/models/trash_model.dart';
import 'package:crossplatform_auth_flutter/utils/services/map_routes_service/map_routes_service.dart';
import 'package:flutter/material.dart';
import 'package:crossplatform_auth_flutter/widgets/avatar_pin_widget.dart';
import 'package:crossplatform_auth_flutter/widgets/theme_toggle_button.dart';
import 'package:crossplatform_auth_flutter/widgets/user_profile_button.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen>
    with MapLocatorUtils, MapRoutesService {
  final MapController _mapController = MapController();
  Position? _myPosition;
  List<TrashModel> _trashList = [];
  List<int> _selectedTrashIds = [];
  List<LatLng>? _route;
  bool _isLoading = false;
  bool _isGeneratingRoute = false;
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void _initLocationTracking() {
    // Busca a localização inicial
    _updateLocation(true);

    // Configura o timer para atualizar a cada 5 segundos
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateLocation(false);
    });
  }

  Future<void> _updateLocation(bool isFirstLocation) async {
    if (isFirstLocation) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      Position? newPosition = await getCurrentPosition();

      if (newPosition != null) {
        if (isFirstLocation) {
          _trashList = mockTrashPositions(
            referencePosition: newPosition,
            radiusInMeters: 5000,
            quantity: 10,
          );
        }
        // Verifica se a posição mudou significativamente (mais de 10 metros)
        if (_myPosition == null ||
            _calculateDistance(_myPosition!, newPosition) > 10) {
          setState(() {
            _myPosition = newPosition;
          });

          // Se é a primeira localização, centraliza o mapa
          if (isFirstLocation) {
            _centerMapOnLocation();
          }
        }
      }
    } catch (e) {
      // Trata erros silenciosamente para não interromper o timer
    } finally {
      if (isFirstLocation) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _centerMapOnLocation() {
    if (_myPosition != null) {
      _mapController.move(
        LatLng(_myPosition!.latitude, _myPosition!.longitude),
        15.0,
      );
    }
  }

  void _generateRoute() async {
    setState(() {
      _isGeneratingRoute = true;
    });
    if (_selectedTrashIds.isNotEmpty) {
      LatLng start = LatLng(_myPosition!.latitude, _myPosition!.longitude);
      List<LatLng> waypoints = _trashList
          .where((trash) => _selectedTrashIds.contains(trash.id))
          .map(
            (trash) =>
                LatLng(trash.position.latitude, trash.position.longitude),
          )
          .toList();
      if (waypoints.length > 1) {
        waypoints.insert(0, start);
        List<LatLng> route = await getRouteWithWaypoints(waypoints);
        setState(() {
          _route = route;
        });
      } else {
        List<LatLng> route = await getRoute(start, waypoints.first);
        setState(() {
          _route = route;
        });
      }
    } else {
      ToastShow.showToast(
        title: LabelsEnum.selectAtLeastOneItem,
        type: ToastificationType.error,
      );
    }
    setState(() {
      _isGeneratingRoute = false;
    });
  }

  void _clearRoute() {
    setState(() {
      _route = null;
      _selectedTrashIds = [];
    });
  }

  void _addTrashPoint() {
    if (_myPosition == null) {
      ToastShow.showToast(
        title: LabelsEnum.locationNotAvailable,
        type: ToastificationType.error,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(LabelsEnum.addCollectionPoint),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(LabelsEnum.selectTrashType),
              const SizedBox(height: 16),
              ...TrashTypeEnum.values.map((trashType) {
                return ListTile(
                  leading: Icon(trashType.icon, color: trashType.color),
                  title: Text(trashType.name),
                  onTap: () {
                    Navigator.of(context).pop();
                    _addTrashToMap(trashType);
                  },
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(LabelsEnum.cancel),
            ),
          ],
        );
      },
    );
  }

  void _addTrashToMap(TrashTypeEnum trashType) {
    if (_myPosition == null) return;

    // Gera um ID único para o novo ponto
    int newId = DateTime.now().millisecondsSinceEpoch;

    // Cria o novo TrashModel
    TrashModel newTrash = TrashModel(
      id: newId,
      position: _myPosition!,
      trashType: trashType,
    );

    setState(() {
      _trashList.add(newTrash);
    });

    ToastShow.showToast(
      title: LabelsEnum.collectionPointAdded,
      type: ToastificationType.success,
    );
  }

  double _calculateDistance(Position pos1, Position pos2) {
    const Distance distance = Distance();
    return distance.as(
      LengthUnit.Meter,
      LatLng(pos1.latitude, pos1.longitude),
      LatLng(pos2.latitude, pos2.longitude),
    );
  }

  void _toggleTrashSelection(int trashId) {
    setState(() {
      if (_selectedTrashIds.contains(trashId)) {
        _selectedTrashIds.remove(trashId);
        if (_selectedTrashIds.isEmpty) {
          _route = null;
        }
      } else {
        _selectedTrashIds.insert(0, trashId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 40,
              child: const Image(
                image: AssetImage('assets/images/logo_blank_50x50.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(width: 8),
            const Text(LabelsEnum.mainPageTitle),
          ],
        ),
        centerTitle: false,
        actions: [
          // Toggle do tema
          const ThemeToggleButton(),

          // Botão de perfil do usuário
          const UserProfileButton(),

          const SizedBox(width: 8), // Espaçamento
        ],
      ),
      body: Stack(
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return FlutterMap(
                mapController: _mapController,
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (_route != null)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _route!,
                          color: Colors.blue,
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      if (_myPosition != null)
                        Marker(
                          point: LatLng(
                            _myPosition!.latitude,
                            _myPosition!.longitude,
                          ),
                          child: AvatarPinWidget(userProvider: userProvider),
                        ),
                      for (var trash in _trashList)
                        Marker(
                          point: LatLng(
                            trash.position.latitude,
                            trash.position.longitude,
                          ),
                          child: InkWell(
                            onTap: () => _toggleTrashSelection(trash.id),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Círculo de fundo para marcadores selecionados
                                if (_selectedTrashIds.contains(trash.id))
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                // Ícone do tipo de lixo
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: _selectedTrashIds.contains(trash.id)
                                        ? Colors.blue.withValues(alpha: 0.2)
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    trash.trashType.icon,
                                    color: trash.trashType.color,
                                    size: _selectedTrashIds.contains(trash.id)
                                        ? 26
                                        : 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
          // Loading indicator
          if (_isLoading)
            const Positioned(
              top: 20,
              right: 20,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(LabelsEnum.updatingLocation),
                    ],
                  ),
                ),
              ),
            ),
          // Botão para centralizar no usuário
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedTrashIds.isEmpty)
                  Tooltip(
                    message: LabelsEnum.addCollectionPointTooltip,
                    child: FloatingActionButton(
                      onPressed: _addTrashPoint,
                      mini: true,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.add_rounded, color: Colors.white),
                    ),
                  ),
                if (_route != null)
                  Tooltip(
                    message: LabelsEnum.clearRouteTooltip,
                    child: FloatingActionButton(
                      onPressed: _clearRoute,
                      mini: true,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.clear_rounded, color: Colors.white),
                    ),
                  ),
                SizedBox(height: 10),
                Tooltip(
                  message: _route != null
                      ? LabelsEnum.recalculateRouteTooltip
                      : LabelsEnum.generateRouteTooltip,
                  child: FloatingActionButton(
                    onPressed: _generateRoute,
                    mini: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      _route != null
                          ? Icons.replay_circle_filled_rounded
                          : Icons.roundabout_left_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Tooltip(
                  message: LabelsEnum.centerLocationTooltip,
                  child: FloatingActionButton(
                    onPressed: _centerMapOnLocation,
                    mini: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (_isGeneratingRoute)
            const Positioned(
              top: 20,
              right: 20,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(LabelsEnum.generatingRoute),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
