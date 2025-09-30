class UbicacionService {
  final double velocidad; // en m/s
  final double distancia; // en metros

  UbicacionService({this.velocidad = 0.0, this.distancia = 0.0});

  // velocidad de m/s a km/h
  double get velocidadEnKmh => velocidad * 3.6;

  // distancia de metros a km
  double get distanciaEnKm => distancia / 1000;

  
}