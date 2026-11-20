// KORMI - Location Service
// Live Location + Mill এর ভিতরে / বাইরে Check
// Worker Location List - Admin / Management দেখবে, Worker শুধু নিজেরটা দেখবে

import 'dart:math' as math;

class MillLocation {
  final String name;
  final double lat;
  final double lng;
  final double radiusMeter; // Mill এর Radius

  const MillLocation({
    required this.name,
    required this.lat,
    required this.lng,
    this.radiusMeter = 300,
  });
}

class LocationService {
  // Mill Locations - Kumira / Sitakunda / Bhatiary
  static const List<MillLocation> mills = [
    MillLocation(name: 'Mill 1 - Kumira', lat: 22.4823, lng: 91.7132, radiusMeter: 300),
    MillLocation(name: 'Mill 2 - Sitakunda', lat: 22.5921, lng: 91.6625, radiusMeter: 300),
    MillLocation(name: 'Mill 3 - Bhatiary', lat: 22.4210, lng: 91.7650, radiusMeter: 250),
  ];

  // Haversine Formula - 2 Location এর দূরত্ব Meter এ
  static double distanceInMeters(double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371000.0; // Meter
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) * math.cos(_toRad(lat2)) *
            math.sin(dLng / 2) * math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRad(double deg) => deg * math.pi / 180;

  // Worker Mill এর ভিতরে আছে কিনা
  static bool isInsideMill(double userLat, double userLng, MillLocation mill) {
    final dist = distanceInMeters(userLat, userLng, mill.lat, mill.lng);
    return dist <= mill.radiusMeter;
  }

  // কোন Mill এর ভিতরে আছে, না থাকলে null
  static MillLocation? findCurrentMill(double userLat, double userLng) {
    for (final m in mills) {
      if (isInsideMill(userLat, userLng, m)) return m;
    }
    return null;
  }

  // Status Text - Inside / Outside
  static String statusText(double userLat, double userLng) {
    final mill = findCurrentMill(userLat, userLng);
    if (mill != null) return 'Inside Mill - ${mill.name}';
    return 'Outside';
  }

  // Distance Text - "120m দূরে" / "1.2km দূরে"
  static String distanceText(double userLat, double userLng, MillLocation mill) {
    final d = distanceInMeters(userLat, userLng, mill.lat, mill.lng);
    if (d < 1000) return '${d.toStringAsFixed(0)}m দূরে';
    return '${(d / 1000).toStringAsFixed(1)}km দূরে';
  }

  // Location Share Text - WhatsApp / Message এ পাঠানোর জন্য
  static String buildLocationShareText({
    required String workerName,
    required String card,
    required double lat,
    required double lng,
    required DateTime time,
  }) {
    final mill = findCurrentMill(lat, lng);
    final status = mill != null ? 'Inside - ${mill.name}' : 'Outside';
    return 'Location Update\nWorker: $workerName ($card)\nStatus: $status\nLat: $lat, Lng: $lng\nTime: ${time.hour}:${time.minute.toString().padLeft(2, '0')}\nMap: https://maps.google.com/?q=$lat,$lng';
  }

  // Demo Location - Testing এর জন্য, আসল GPS লাগানোর আগে
  static Map<String, double> demoInsideLocation() {
    return {'lat': 22.4825, 'lng': 91.7135}; // Mill 1 এর ভিতরে
  }

  static Map<String, double> demoOutsideLocation() {
    return {'lat': 22.5000, 'lng': 91.7300}; // Kumira Bazar - বাইরে
  }
}
