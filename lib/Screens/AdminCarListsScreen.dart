import 'package:bidding_admin/Models/item_model.dart';
import 'package:bidding_admin/Screens/AdminAddData.dart';
import 'package:bidding_admin/WidgetsScreen/CustomListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Admincarlistsscreen extends StatefulWidget {
  const Admincarlistsscreen({super.key});

  @override
  State<Admincarlistsscreen> createState() => _AdmincarlistsscreenState();
}

class _AdmincarlistsscreenState extends State<Admincarlistsscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Admin Car Lists Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('itemModel').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final itemData =
                  ItemModel.fromJson(doc.data() as Map<String, dynamic>);
              if (itemData.itemId == null || itemData.itemId!.isEmpty) {
                itemData.itemId = doc.id;
              }
              return Card(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Adminadddata(item: itemData),
                    ),
                  ),
                  child: Customlisttile(
                    title: Text('Car Name: ${itemData.title ?? 'N/A'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('car price: ${itemData.sellerPrice?.toString() ?? 'N/A'} ||  car model: ${itemData.model ?? 'N/A'}'),
                        Text('car active: ${itemData.isActive?.toString() ?? 'N/A'}'),
                        Text('car created: ${itemData.createdAt?.toString() ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}