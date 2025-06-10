class Request {
  final int id;
  final String serviceType;
  final String description;
  final String urgency;
  final double budget;
  final String status;
  final DateTime? scheduledDate;
  final DateTime createdAt;
  final String? providerName;
  final String? providerPhone;
  final double? rating;
  final String? review;
  final int? requesterId;
  final int? providerId;

  Request({
    required this.id,
    required this.serviceType,
    required this.description,
    required this.urgency,
    required this.budget,
    required this.status,
    this.scheduledDate,
    required this.createdAt,
    this.providerName,
    this.providerPhone,
    this.rating,
    this.review,
    this.requesterId,
    this.providerId,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] ?? json['request_id'] ?? 0,
      serviceType: json['serviceType'] ?? '',
      description: json['description'] ?? '',
      urgency: json['urgency'] ?? '',
      budget: (json['budget'] is int)
          ? (json['budget'] as int).toDouble()
          : (json['budget'] is String)
              ? double.tryParse(json['budget']) ?? 0.0
              : (json['budget'] ?? 0.0),
      status: json['status'] ?? '',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.tryParse(json['scheduledDate'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      providerName: json['providerName'] ?? json['provider_name'],
      providerPhone: json['providerPhone'] ?? json['provider_phone'],
      rating: json['rating'] != null
          ? (json['rating'] is int)
              ? (json['rating'] as int).toDouble()
              : (json['rating'] is String)
                  ? double.tryParse(json['rating'])
                  : json['rating']
          : null,
      review: json['review'],
      requesterId: json['requesterId'] ?? json['requester_id'],
      providerId: json['providerId'] ?? json['provider_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceType': serviceType,
      'description': description,
      'urgency': urgency,
      'budget': budget,
      'status': status,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'providerName': providerName,
      'providerPhone': providerPhone,
      'rating': rating,
      'review': review,
      'requesterId': requesterId,
      'providerId': providerId,
    };
  }

  Request copyWith({
    int? id,
    String? serviceType,
    String? description,
    String? urgency,
    double? budget,
    String? status,
    DateTime? scheduledDate,
    DateTime? createdAt,
    String? providerName,
    String? providerPhone,
    double? rating,
    String? review,
    int? requesterId,
    int? providerId,
  }) {
    return Request(
      id: id ?? this.id,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      urgency: urgency ?? this.urgency,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      createdAt: createdAt ?? this.createdAt,
      providerName: providerName ?? this.providerName,
      providerPhone: providerPhone ?? this.providerPhone,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      requesterId: requesterId ?? this.requesterId,
      providerId: providerId ?? this.providerId,
    );
  }
} 