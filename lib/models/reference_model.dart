// models/reference_model.dart
class Reference {
  final int reference;
  final String client;
  final String containerNumber;
  final String loadingArea;
  final DateTime? releaseStartDate;
  final String? releaseStartTime;
  final DateTime? releaseFinishDate;
  final String? releaseFinishTime;
  final DateTime? sampleStartDate;
  final String? sampleStartTime;
  final DateTime? sampleFinishDate;
  final String? sampleFinishTime;
  final DateTime? stampedDate;
  final String? stampedTime;
  final double? releaseTemperature;
  final double? sampleTemperature;
  final double? stampedTemperature;
  final bool isSynced;

  Reference({
    required this.reference,
    required this.client,
    required this.containerNumber,
    required this.loadingArea,
    this.releaseStartDate,
    this.releaseStartTime,
    this.releaseFinishDate,
    this.releaseFinishTime,
    this.sampleStartDate,
    this.sampleStartTime,
    this.sampleFinishDate,
    this.sampleFinishTime,
    this.stampedDate,
    this.stampedTime,
    this.releaseTemperature,
    this.sampleTemperature,
    this.stampedTemperature,
    this.isSynced = false,
  });

  // Método copyWith para crear copias modificadas
  Reference copyWith({
    int? reference,
    String? client,
    String? containerNumber,
    String? loadingArea,
    DateTime? releaseStartDate,
    String? releaseStartTime,
    DateTime? releaseFinishDate,
    String? releaseFinishTime,
    DateTime? sampleStartDate,
    String? sampleStartTime,
    DateTime? sampleFinishDate,
    String? sampleFinishTime,
    DateTime? stampedDate,
    String? stampedTime,
    double? releaseTemperature,
    double? sampleTemperature,
    double? stampedTemperature,
    bool? isSynced,
  }) {
    return Reference(
      reference: reference ?? this.reference,
      client: client ?? this.client,
      containerNumber: containerNumber ?? this.containerNumber,
      loadingArea: loadingArea ?? this.loadingArea,
      releaseStartDate: releaseStartDate ?? this.releaseStartDate,
      releaseStartTime: releaseStartTime ?? this.releaseStartTime,
      releaseFinishDate: releaseFinishDate ?? this.releaseFinishDate,
      releaseFinishTime: releaseFinishTime ?? this.releaseFinishTime,
      sampleStartDate: sampleStartDate ?? this.sampleStartDate,
      sampleStartTime: sampleStartTime ?? this.sampleStartTime,
      sampleFinishDate: sampleFinishDate ?? this.sampleFinishDate,
      sampleFinishTime: sampleFinishTime ?? this.sampleFinishTime,
      stampedDate: stampedDate ?? this.stampedDate,
      stampedTime: stampedTime ?? this.stampedTime,
      releaseTemperature: releaseTemperature ?? this.releaseTemperature,
      sampleTemperature: sampleTemperature ?? this.sampleTemperature,
      stampedTemperature: stampedTemperature ?? this.stampedTemperature,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      reference: json['reference'] as int,
      client: (json['client'] as String).trim(),
      containerNumber: (json['containerNumber'] as String).trim(),
      loadingArea: json['loadingArea'],
      releaseStartDate: json['releaseStartDate'] != null
          ? DateTime.parse(json['releaseStartDate'])
          : null,
      releaseStartTime: json['releaseStartTime'],
      releaseFinishDate: json['releaseFinishDate'] != null
          ? DateTime.parse(json['releaseFinishDate'])
          : null,
      releaseFinishTime: json['releaseFinishTime'],
      sampleStartDate: json['sampleStartDate'] != null
          ? DateTime.parse(json['sampleStartDate'])
          : null,
      sampleStartTime: json['sampleStartTime'],
      sampleFinishDate: json['sampleFinishDate'] != null
          ? DateTime.parse(json['sampleFinishDate'])
          : null,
      sampleFinishTime: json['sampleFinishTime'],
      stampedDate: json['stampedDate'] != null
          ? DateTime.parse(json['stampedDate'])
          : null,
      stampedTime: json['stampedTime'],
      releaseTemperature: json['releaseTemperature']?.toDouble(),
      sampleTemperature: json['sampleTemperature']?.toDouble(),
      stampedTemperature: json['stampedTemperature']?.toDouble(),
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'client': client,
      'containerNumber': containerNumber,
      'loadingArea': loadingArea,
      'releaseStartDate': releaseStartDate?.toIso8601String(),
      'releaseStartTime': releaseStartTime,
      'releaseFinishDate': releaseFinishDate?.toIso8601String(),
      'releaseFinishTime': releaseFinishTime,
      'sampleStartDate': sampleStartDate?.toIso8601String(),
      'sampleStartTime': sampleStartTime,
      'sampleFinishDate': sampleFinishDate?.toIso8601String(),
      'sampleFinishTime': sampleFinishTime,
      'stampedDate': stampedDate?.toIso8601String(),
      'stampedTime': stampedTime,
      'releaseTemperature': releaseTemperature,
      'sampleTemperature': sampleTemperature,
      'stampedTemperature': stampedTemperature,
      'isSynced': isSynced,
    };
  }

  bool get isComplete {
    return releaseStartDate != null &&
        releaseStartTime != null &&
        releaseFinishDate != null &&
        releaseFinishTime != null &&
        sampleStartDate != null &&
        sampleStartTime != null &&
        sampleFinishDate != null &&
        sampleFinishTime != null &&
        stampedDate != null &&
        stampedTime != null &&
        releaseTemperature != null &&
        sampleTemperature != null &&
        stampedTemperature != null;
  }
}
