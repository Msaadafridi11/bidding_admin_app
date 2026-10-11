import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  // Basic
  String? itemId;
  String? title;
  String? description;
  String? make;
  String? model;
  int? year;

  // Pricing / Bidding
  double? sellerPrice;
  double? minimumBid;
  double? currentBid;
  DateTime? bidEndTime;
  bool? isActive;

  // Car details
  int? mileage;
  String? registeredIn;
  String? bodyType;
  String? engineSize;
  int? numberOfCylinders;
  String? fuelType;
  String? transmission;
  String? wheelType;
  String? carOptions;
  String? safetyBeltStatus;

  String? trim;
  String? interiorType;
  int? keys;
  String? specification;
  String? exteriorColor;
  String? enteriorColor;
  String? firstOwner;
  String? wheels;

  // Expandable sections / Conditions
  String? exteriorCondition;
  String? history;
  String? steering;
  String? interior;
  String? specs;

  // Meta
  DateTime? createdAt;
  String? currentBidUserId;

  // Winner
  String? winnerUserId;
  double? winnerBidAmount;
  DateTime? auctionEndedAt;

  List<String>? imageUrls;

  ItemModel({
    this.itemId,
    this.title,
    this.description,
    this.make,
    this.model,
    this.year,
    this.sellerPrice,
    this.minimumBid,
    this.currentBid,
    this.bidEndTime,
    this.isActive,
    this.mileage,
    this.registeredIn,
    this.bodyType,
    this.engineSize,
    this.numberOfCylinders,
    this.fuelType,
    this.transmission,
    this.wheelType,
    this.carOptions,
    this.safetyBeltStatus,
    this.trim,
    this.interiorType,
    this.keys,
    this.specification,
    this.exteriorColor,
    this.enteriorColor,
    this.firstOwner,
    this.wheels,
    this.exteriorCondition,
    this.history,
    this.steering,
    this.interior,
    this.specs,
    this.createdAt,
    this.currentBidUserId,
    this.winnerUserId,
    this.winnerBidAmount,
    this.auctionEndedAt,
    this.imageUrls,
  });

  static DateTime? _parseDateTime(dynamic val) {
    if (val == null) return null;
    if (val is Timestamp) return val.toDate();
    if (val is DateTime) return val;
    if (val is String) return DateTime.tryParse(val);
    return null;
  }

  static double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    if (val is String) return double.tryParse(val);
    return null;
  }

  static int? _parseInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val);
    return null;
  }

  factory ItemModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    List<String>? urls;
    if (map['imageUrls'] != null) {
      urls = List<String>.from((map['imageUrls'] as List).map((e) => e.toString()));
    }

    return ItemModel(
      itemId: (map['itemId'] as String?) ?? docId,
      title: map['title'] as String?,
      description: map['description'] as String?,
      make: map['make'] as String?,
      model: map['model'] as String?,
      year: _parseInt(map['year']),
      sellerPrice: _parseDouble(map['sellerPrice']),
      minimumBid: _parseDouble(map['minimumBid']),
      currentBid: _parseDouble(map['currentBid']),
      bidEndTime: _parseDateTime(map['bidEndTime']),
      isActive: map['isActive'] as bool?,
      mileage: _parseInt(map['mileage']),
      registeredIn: map['registeredIn'] as String?,
      bodyType: map['bodyType'] as String?,
      engineSize: map['engineSize']?.toString(),
      numberOfCylinders: _parseInt(map['numberOfCylinders']),
      fuelType: map['fuelType'] as String?,
      transmission: map['transmission'] as String?,
      wheelType: map['wheelType'] as String?,
      carOptions: map['carOptions'] as String?,
      safetyBeltStatus: map['safetyBeltStatus'] as String?,
      trim: map['trim'] as String?,
      interiorType: map['interiorType'] as String?,
      keys: _parseInt(map['keys']),
      specification: map['specification'] as String?,
      exteriorColor: map['exteriorColor'] as String?,
      enteriorColor: (map['enteriorColor'] ?? map['interiorColor']) as String?,
      firstOwner: map['firstOwner'] as String?,
      wheels: map['wheels'] as String?,
      exteriorCondition: map['exteriorCondition'] as String?,
      history: map['history'] as String?,
      steering: (map['steering'] ?? map['steeringCondition']) as String?,
      interior: (map['interior'] ?? map['interiorCondition']) as String?,
      specs: map['specs'] as String?,
      createdAt: _parseDateTime(map['createdAt']),
      currentBidUserId: map['currentBidUserId'] as String?,
      winnerUserId: map['winnerUserId'] as String?,
      winnerBidAmount: _parseDouble(map['winnerBidAmount']),
      auctionEndedAt: _parseDateTime(map['auctionEndedAt']),
      imageUrls: urls,
    );
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (itemId != null) 'itemId': itemId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (sellerPrice != null) 'sellerPrice': sellerPrice,
      if (minimumBid != null) 'minimumBid': minimumBid,
      if (currentBid != null) 'currentBid': currentBid,
      if (bidEndTime != null) 'bidEndTime': bidEndTime?.toIso8601String(),
      if (isActive != null) 'isActive': isActive,
      if (mileage != null) 'mileage': mileage,
      if (registeredIn != null) 'registeredIn': registeredIn,
      if (bodyType != null) 'bodyType': bodyType,
      if (engineSize != null) 'engineSize': engineSize,
      if (numberOfCylinders != null) 'numberOfCylinders': numberOfCylinders,
      if (fuelType != null) 'fuelType': fuelType,
      if (transmission != null) 'transmission': transmission,
      if (wheelType != null) 'wheelType': wheelType,
      if (carOptions != null) 'carOptions': carOptions,
      if (safetyBeltStatus != null) 'safetyBeltStatus': safetyBeltStatus,
      if (trim != null) 'trim': trim,
      if (interiorType != null) 'interiorType': interiorType,
      if (keys != null) 'keys': keys,
      if (specification != null) 'specification': specification,
      if (exteriorColor != null) 'exteriorColor': exteriorColor,
      if (enteriorColor != null) 'enteriorColor': enteriorColor,
      if (firstOwner != null) 'firstOwner': firstOwner,
      if (wheels != null) 'wheels': wheels,
      if (exteriorCondition != null) 'exteriorCondition': exteriorCondition,
      if (history != null) 'history': history,
      if (steering != null) 'steering': steering,
      if (interior != null) 'interior': interior,
      if (specs != null) 'specs': specs,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (currentBidUserId != null) 'currentBidUserId': currentBidUserId,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      if (winnerBidAmount != null) 'winnerBidAmount': winnerBidAmount,
      if (auctionEndedAt != null) 'auctionEndedAt': auctionEndedAt?.toIso8601String(),
      if (imageUrls != null) 'imageUrls': imageUrls,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  ItemModel copyWith({
    String? itemId,
    String? title,
    String? description,
    String? make,
    String? model,
    int? year,
    double? sellerPrice,
    double? minimumBid,
    double? currentBid,
    DateTime? bidEndTime,
    bool? isActive,
    int? mileage,
    String? registeredIn,
    String? bodyType,
    String? engineSize,
    int? numberOfCylinders,
    String? fuelType,
    String? transmission,
    String? wheelType,
    String? carOptions,
    String? safetyBeltStatus,
    String? trim,
    String? interiorType,
    int? keys,
    String? specification,
    String? exteriorColor,
    String? enteriorColor,
    String? firstOwner,
    String? wheels,
    String? exteriorCondition,
    String? history,
    String? steering,
    String? interior,
    String? specs,
    DateTime? createdAt,
    String? currentBidUserId,
    String? winnerUserId,
    double? winnerBidAmount,
    DateTime? auctionEndedAt,
    List<String>? imageUrls,
  }) {
    return ItemModel(
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      description: description ?? this.description,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      sellerPrice: sellerPrice ?? this.sellerPrice,
      minimumBid: minimumBid ?? this.minimumBid,
      currentBid: currentBid ?? this.currentBid,
      bidEndTime: bidEndTime ?? this.bidEndTime,
      isActive: isActive ?? this.isActive,
      mileage: mileage ?? this.mileage,
      registeredIn: registeredIn ?? this.registeredIn,
      bodyType: bodyType ?? this.bodyType,
      engineSize: engineSize ?? this.engineSize,
      numberOfCylinders: numberOfCylinders ?? this.numberOfCylinders,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      wheelType: wheelType ?? this.wheelType,
      carOptions: carOptions ?? this.carOptions,
      safetyBeltStatus: safetyBeltStatus ?? this.safetyBeltStatus,
      trim: trim ?? this.trim,
      interiorType: interiorType ?? this.interiorType,
      keys: keys ?? this.keys,
      specification: specification ?? this.specification,
      exteriorColor: exteriorColor ?? this.exteriorColor,
      enteriorColor: enteriorColor ?? this.enteriorColor,
      firstOwner: firstOwner ?? this.firstOwner,
      wheels: wheels ?? this.wheels,
      exteriorCondition: exteriorCondition ?? this.exteriorCondition,
      history: history ?? this.history,
      steering: steering ?? this.steering,
      interior: interior ?? this.interior,
      specs: specs ?? this.specs,
      createdAt: createdAt ?? this.createdAt,
      currentBidUserId: currentBidUserId ?? this.currentBidUserId,
      winnerUserId: winnerUserId ?? this.winnerUserId,
      winnerBidAmount: winnerBidAmount ?? this.winnerBidAmount,
      auctionEndedAt: auctionEndedAt ?? this.auctionEndedAt,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
