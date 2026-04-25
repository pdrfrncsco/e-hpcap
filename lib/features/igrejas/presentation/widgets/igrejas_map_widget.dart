import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/igrejas_providers.dart';
import '../../domain/models/igreja.dart';

class IgrejasMapWidget extends ConsumerStatefulWidget {
  const IgrejasMapWidget({super.key});

  @override
  ConsumerState<IgrejasMapWidget> createState() => _IgrejasMapWidgetState();
}

class _IgrejasMapWidgetState extends ConsumerState<IgrejasMapWidget> {
  final MapController _mapController = MapController();
  LatLng? _initialPosition;
  String? _lastFittedMarkersKey;
  bool _isMapReady = false;

  static const LatLng _defaultPosition =
      LatLng(-8.8383, 13.2344); // Luanda, Angola

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final position = await ref.read(localizacaoProvider.future);
      if (position != null && mounted) {
        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);
        });
      } else {
        setState(() {
          _initialPosition = _defaultPosition;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _initialPosition = _defaultPosition;
        });
      }
    }
  }

  Future<void> _animateToUserLocation() async {
    if (!_isMapReady) return;

    final position = await ref.read(localizacaoProvider.future);
    if (position != null) {
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        14,
      );
    }
  }

  List<Igreja> _getIgrejasComCoordenadas(List<Igreja> igrejas) {
    return igrejas
        .where((igreja) => igreja.latitude != null && igreja.longitude != null)
        .toList();
  }

  void _fitMapToIgrejas(List<Igreja> igrejas) {
    if (!_isMapReady || igrejas.isEmpty) return;

    final markersKey = igrejas.map((igreja) => igreja.id).join(',');
    if (_lastFittedMarkersKey == markersKey) return;

    final coordinates = igrejas
        .map((igreja) => LatLng(igreja.latitude!, igreja.longitude!))
        .toList();
    if (coordinates.isEmpty) return;

    if (coordinates.length == 1) {
      _mapController.move(coordinates.first, 14);
    } else {
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: coordinates,
          padding: const EdgeInsets.fromLTRB(48, 48, 48, 120),
          maxZoom: 14,
        ),
      );
    }

    _lastFittedMarkersKey = markersKey;
  }

  List<Marker> _buildMarkers(List<Igreja> igrejas) {
    return _getIgrejasComCoordenadas(igrejas).map((igreja) {
      final color = _getMarkerColor(igreja);
      return Marker(
        point: LatLng(igreja.latitude!, igreja.longitude!),
        width: 44,
        height: 44,
        child: GestureDetector(
          onTap: () => context.go('/igrejas/${igreja.id}'),
          child: Tooltip(
            message:
                '${igreja.nome}\n${igreja.cidade.trim().isEmpty ? "Localização" : igreja.cidade} • ${igreja.distritoNome ?? ""}',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.28),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.church,
                color: color,
                size: 32,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Color _getMarkerColor(Igreja igreja) {
    // Different colors for different conferences
    switch (igreja.conferenciaCodigo) {
      case 'CAOA':
        return Colors.red;
      case 'CALA':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final igrejasAsync = ref.watch(igrejasListProvider);
    final theme = Theme.of(context);
    final igrejasComCoordenadas = igrejasAsync.maybeWhen(
      data: _getIgrejasComCoordenadas,
      orElse: () => const <Igreja>[],
    );

    if (igrejasComCoordenadas.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fitMapToIgrejas(igrejasComCoordenadas);
        }
      });
    } else if (igrejasAsync.hasValue) {
      _lastFittedMarkersKey = null;
    }

    if (_initialPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _initialPosition!,
            initialZoom: 10,
            onMapReady: () {
              if (!mounted) return;
              setState(() {
                _isMapReady = true;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.hpcapp.hpc',
              maxZoom: 19,
            ),
            MarkerLayer(
              markers: igrejasAsync.maybeWhen(
                data: (igrejas) => _buildMarkers(igrejas),
                orElse: () => [],
              ),
            ),
          ],
        ),

        // My Location Button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.small(
            heroTag: 'my_location',
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
            onPressed: _animateToUserLocation,
            child: const Icon(Icons.my_location),
          ),
        ),

        // Loading indicator
        if (igrejasAsync.isLoading)
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('A carregar igrejas...'),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Error indicator
        if (igrejasAsync.hasError)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Erro ao carregar igrejas',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(igrejasListProvider),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),

        if (igrejasAsync.hasValue && igrejasComCoordenadas.isEmpty)
          const Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Nenhuma igreja com coordenadas válidas para mostrar no mapa.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '© OpenStreetMap',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
