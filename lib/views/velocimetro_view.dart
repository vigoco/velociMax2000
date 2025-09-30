// lib/views/velocimetro_view.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:velocimax2000/viewmodels/velocimetro_viewmodel.dart';

class VelocimetroView extends StatefulWidget {
  const VelocimetroView({super.key});

  @override
  State<VelocimetroView> createState() => _VelocimetroViewState();
}

class _VelocimetroViewState extends State<VelocimetroView> {
  final VelocimetroViewModel _viewModel = VelocimetroViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color colorPrincipal = Color(0xFFFF7B00);
    const Color colorFondo = Color(0xFF202C59);

    // Usamos OrientationBuilder para detectar el giro
    Widget contenido = _viewModel.tienePermiso
        ? OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                // Si es vertical, usamos el layout de Columna
                return _buildContenidoPortrait(colorPrincipal);
              } else {
                // Si es horizontal, usamos el layout de Fila
                return _buildContenidoLandscape(colorPrincipal);
              }
            },
          )
        : _buildMensajePermisos();
    
    if (_viewModel.modoHUD) {
      contenido = Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: contenido,
      );
    }

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text('VelociMax2000'),
        backgroundColor: colorFondo,
        foregroundColor: colorPrincipal,
        elevation: 0,
         actions: [
           IconButton(
             icon: Icon(_viewModel.modoHUD ? Icons.flip_camera_android_outlined : Icons.flip_camera_android),
             onPressed: _viewModel.alternarModoHUD,
             tooltip: 'Modo HUD',
           )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: contenido),
      ),
    );
  }

  Widget _buildContenidoPortrait(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildVelocidadDisplay(color),
        const SizedBox(height: 40),
        _buildOdometroYReset(color),
      ],
    );
  }

  Widget _buildContenidoLandscape(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildVelocidadDisplay(color),
        ),
        const VerticalDivider(color: Colors.white24, indent: 20, endIndent: 20),
        Expanded(
          child: _buildOdometroYReset(color),
        ),
      ],
    );
  }

  Widget _buildVelocidadDisplay(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _viewModel.ubicacionData.velocidadEnKmh.toStringAsFixed(0),
          style: TextStyle(
            color: color,
            fontSize: 150, // Ligeramente más pequeño para que quepa mejor
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace'
          ),
        ),
        Text(
          'km/h',
          style: TextStyle(
            color: color,
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildOdometroYReset(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Distancia',
          style: TextStyle(
            color: color,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${_viewModel.ubicacionData.distanciaEnKm.toStringAsFixed(2)} km',
          style: TextStyle(
            color: color,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace'
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _viewModel.resetearDistancia,
          icon: const Icon(Icons.refresh, color: Color(0xFF202C59)),
          label: const Text('Resetear', style: TextStyle(color: Color(0xFF202C59), fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMensajePermisos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, color: Colors.white, size: 80),
          const SizedBox(height: 20),
          Text(
            'Permiso de ubicación denegado.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 10),
          Text(
            'Por favor, habilita el permiso en los ajustes de la aplicación para usar el velocímetro.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}