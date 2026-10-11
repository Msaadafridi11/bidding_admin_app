// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../views/car/admin_add_car_view.dart';

class Adminadddata extends StatelessWidget {
  final ItemModel? item;

  const Adminadddata({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return AdminAddCarView(item: item);
  }
}
