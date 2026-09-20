import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable(explicitToJson: true)
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

  // Expandable sections
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
   this.imageUrls,
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
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}
