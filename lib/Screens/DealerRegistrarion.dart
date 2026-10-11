// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../views/dealer/dealer_details_view.dart';

class Dealerregistrarion extends StatelessWidget {
  final UserModel? dealerData;

  const Dealerregistrarion({super.key, this.dealerData});

  @override
  Widget build(BuildContext context) {
    return DealerDetailsView(dealerData: dealerData);
  }
}
