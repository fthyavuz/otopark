enum CleaningServiceType {
  interior('interior', 'İç Temizlik', 'Araç içi temizlik'),
  exterior('exterior', 'Dış Temizlik', 'Araç dışı yıkama'),
  interiorExterior('interior_exterior', 'İç + Dış Temizlik', 'İç ve dış temizlik'),
  full('full', 'Tam Temizlik', 'İç + Dış + Motor temizliği');

  const CleaningServiceType(this.value, this.displayName, this.description);

  final String value;
  final String displayName;
  final String description;

  static CleaningServiceType fromValue(String value) =>
      CleaningServiceType.values.firstWhere((t) => t.value == value,
          orElse: () => CleaningServiceType.interior);
}

/// Data passed from cleaning entry screen to service selection screen.
class CleaningEntryData {
  final String plate;
  final bool isLargeVehicle;
  final bool wasParkingCar;

  /// null = not a subscriber; 'daily' or 'monthly'
  final String? subscriberType;

  const CleaningEntryData({
    required this.plate,
    required this.isLargeVehicle,
    required this.wasParkingCar,
    this.subscriberType,
  });
}

/// Data passed from service selection to payment screen.
class CleaningPaymentData {
  final String plate;
  final CleaningServiceType serviceType;
  final double baseCost;
  final double finalCost;
  final double discountPercent;
  final bool isLargeVehicle;
  final bool wasParkingCar;
  final String? notes;

  const CleaningPaymentData({
    required this.plate,
    required this.serviceType,
    required this.baseCost,
    required this.finalCost,
    required this.discountPercent,
    required this.isLargeVehicle,
    required this.wasParkingCar,
    this.notes,
  });
}
