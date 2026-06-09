class VisitorLocation {
  const VisitorLocation({
    required this.city,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  final String city;
  final String region;
  final String country;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  factory VisitorLocation.fromJson(Map<String, dynamic> json) {
    return VisitorLocation(
      city: json['city'] as String? ?? 'Unknown',
      region: json['region'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? 'Unknown',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'region': region,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
