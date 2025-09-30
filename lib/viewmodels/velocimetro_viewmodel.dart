import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velocimax2000/models/services/ubicacion_service.dart';

class VelocimetroViewModel extends ChangeNotifier {
  UbicacionService _ubicacionData = UbicacionService();
  UbicacionService get ubicacionData => _ubicacionData;

  StreamSubscription<Position>? _posicionSubscription;
  double _distanciaTotal = 0.0;
  Position? _ultimaPosicion;
  bool _modoHUD = false;
  bool _tienePermiso = false;

  bool get modoHUD => _modoHUD;
  bool get tienePermiso => _tienePermiso;

  VelocimetroViewModel() {
    _verificarPermiso();
  }

  Future<void> _verificarPermiso() async {
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.always || permiso == LocationPermission.whileInUse) {
      _tienePermiso = true;
      iniciarSeguimiento();
    } else {
      _tienePermiso = false;
    }
    notifyListeners();
  }

   void iniciarSeguimiento() {
    if (_posicionSubscription != null) return;

    const LocationSettings ajustesUbicacion = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // Recibir actualizaciones continuamente
    );

    _posicionSubscription = Geolocator.getPositionStream(locationSettings: ajustesUbicacion).listen(
      (Position posicion) {
        double velocidadActual = posicion.speed; // en m/s
        
        if (_ultimaPosicion != null) {
          double distanciaRecorrida = Geolocator.distanceBetween(
            _ultimaPosicion!.latitude,
            _ultimaPosicion!.longitude,
            posicion.latitude,
            posicion.longitude,
          );
          _distanciaTotal += distanciaRecorrida;
        }
        
        _ultimaPosicion = posicion;
        
        _ubicacionData = UbicacionService(
          velocidad: velocidadActual < 0 ? 0 : velocidadActual, 
          distancia: _distanciaTotal
        );
        
        notifyListeners();
      },
      onError: (error) {
        // print("Error al obtener la ubicación: $error");
      }
    );
  }


  void resetearDistancia() {
    _distanciaTotal = 0.0;
    _ubicacionData = UbicacionService(velocidad: _ubicacionData.velocidad, distancia: _distanciaTotal);
    notifyListeners();
  }

  void alternarModoHUD() {
    _modoHUD = !_modoHUD;
    notifyListeners();
  }

  @override
  void dispose() {
    _posicionSubscription?.cancel();
    super.dispose();
  }
}