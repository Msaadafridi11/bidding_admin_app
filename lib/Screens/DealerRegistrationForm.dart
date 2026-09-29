import 'package:bidding_admin/Models/user_model.dart';
import 'package:bidding_admin/Screens/DealerRegistrarion.dart';
import 'package:bidding_admin/WidgetsScreen/CustomListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dealerregistrationform extends StatefulWidget {
  const Dealerregistrationform({super.key});

  @override
  State<Dealerregistrationform> createState() => _DealerregistrationformState();
}

class _DealerregistrationformState extends State<Dealerregistrationform> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Dealer Registration Form'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('userModel').snapshots(),
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
              final data = doc.data() as Map<String, dynamic>;
              final userModel = UserModel.fromJson(data);
              if (userModel.uid == null || userModel.uid!.isEmpty) {
                userModel.uid = doc.id;
              }
              final bool isNotVerified = userModel.isVerified != true;

              return Card(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Dealerregistrarion(dealerData: userModel),
                    ),
                  ),
                  child: Customlisttile(
                    title: Text('Dealer Name: ${userModel.name ?? 'N/A'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dealer Email: ${userModel.email ?? 'N/A'}'),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        isNotVerified
                            ? const Icon(Icons.cancel, color: Colors.red)
                            : const Icon(Icons.check_circle, color: Colors.green),
                        isNotVerified
                            ? const Text('Not Verified')
                            : const Text('Verified'),
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