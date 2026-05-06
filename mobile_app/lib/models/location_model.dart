// lib/models/location_model.dart
class LocationModel {
  final double lat;
  final double lng;
  final String? vertical;
  final double? heading;

  LocationModel({
    required this.lat,
    required this.lng,
    this.vertical,
    this.heading = 0.0,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      vertical: json['vertical'],
      heading: (json['heading'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      if (vertical != null) 'vertical': vertical,
      'heading': heading,
    };
  }
}
