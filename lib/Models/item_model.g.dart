// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      itemId: json['itemId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      make: json['make'] as String?,
      model: json['model'] as String?,
      year: (json['year'] as num?)?.toInt(),
      sellerPrice: (json['sellerPrice'] as num?)?.toDouble(),
      minimumBid: (json['minimumBid'] as num?)?.toDouble(),
      currentBid: (json['currentBid'] as num?)?.toDouble(),
      bidEndTime: json['bidEndTime'] == null
          ? null
          : DateTime.parse(json['bidEndTime'] as String),
      isActive: json['isActive'] as bool?,
      mileage: (json['mileage'] as num?)?.toInt(),
      registeredIn: json['registeredIn'] as String?,
      bodyType: json['bodyType'] as String?,
      engineSize: json['engineSize'] as String?,
      numberOfCylinders: (json['numberOfCylinders'] as num?)?.toInt(),
      fuelType: json['fuelType'] as String?,
      transmission: json['transmission'] as String?,
      wheelType: json['wheelType'] as String?,
      carOptions: json['carOptions'] as String?,
      safetyBeltStatus: json['safetyBeltStatus'] as String?,
      trim: json['trim'] as String?,
      interiorType: json['interiorType'] as String?,
      keys: (json['keys'] as num?)?.toInt(),
      specification: json['specification'] as String?,
      exteriorColor: json['exteriorColor'] as String?,
      enteriorColor: json['enteriorColor'] as String?,
      firstOwner: json['firstOwner'] as String?,
      wheels: json['wheels'] as String?,
      exteriorCondition: json['exteriorCondition'] as String?,
      history: json['history'] as String?,
      steering: json['steering'] as String?,
      interior: json['interior'] as String?,
      specs: json['specs'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      currentBidUserId: json['currentBidUserId'] as String?,
      winnerUserId: json['winnerUserId'] as String?,
      winnerBidAmount: (json['winnerBidAmount'] as num?)?.toDouble(),
      auctionEndedAt: json['auctionEndedAt'] == null
          ? null
          : DateTime.parse(json['auctionEndedAt'] as String),
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'title': instance.title,
      'description': instance.description,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'sellerPrice': instance.sellerPrice,
      'minimumBid': instance.minimumBid,
      'currentBid': instance.currentBid,
      'bidEndTime': instance.bidEndTime?.toIso8601String(),
      'isActive': instance.isActive,
      'mileage': instance.mileage,
      'registeredIn': instance.registeredIn,
      'bodyType': instance.bodyType,
      'engineSize': instance.engineSize,
      'numberOfCylinders': instance.numberOfCylinders,
      'fuelType': instance.fuelType,
      'transmission': instance.transmission,
      'wheelType': instance.wheelType,
      'carOptions': instance.carOptions,
      'safetyBeltStatus': instance.safetyBeltStatus,
      'trim': instance.trim,
      'interiorType': instance.interiorType,
      'keys': instance.keys,
      'specification': instance.specification,
      'exteriorColor': instance.exteriorColor,
      'enteriorColor': instance.enteriorColor,
      'firstOwner': instance.firstOwner,
      'wheels': instance.wheels,
      'exteriorCondition': instance.exteriorCondition,
      'history': instance.history,
      'steering': instance.steering,
      'interior': instance.interior,
      'specs': instance.specs,
      'createdAt': instance.createdAt?.toIso8601String(),
      'currentBidUserId': instance.currentBidUserId,
      'winnerUserId': instance.winnerUserId,
      'winnerBidAmount': instance.winnerBidAmount,
      'auctionEndedAt': instance.auctionEndedAt?.toIso8601String(),
      'imageUrls': instance.imageUrls,
    };
