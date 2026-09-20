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
  bool  isCheckBinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Dealer Registration Form'),
      ),
    body: FutureBuilder<QuerySnapshot>(future: FirebaseFirestore.instance.collection('userModel').get(), builder: (context, snapshot) {
    if(snapshot.connectionState==ConnectionState.waiting){
    return Center(child: CircularProgressIndicator(),);
    }
    if(snapshot.hasError){
    return Center(child: Text('Error: ${snapshot.error}'),);
    }
    if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
    return Center(child: Text('No Data Found'),);
    }
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        final userModel= UserModel.fromJson(snapshot.data!.docs[index].data()as Map<String, dynamic>);
        isCheckBinner= userModel.isVerified == false;

        return Card(
        child: GestureDetector(

        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Dealerregistrarion(dealerData: userModel))),
        child: Customlisttile(
            title: Text('Dealer Name: ${userModel.name.toString()}'),
        subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dealer Email: ${userModel.email.toString()}'),
        ],
        ),
          trailing: Column(
            children: [
              isCheckBinner?Icon(Icons.cancel,color: Colors.red,):Icon(Icons.check_circle,color: Colors.green,),
              isCheckBinner?Text('Not Verified'):Text('Verified'),
            ],
          ),
        ),
        ),
        );
    });
    }
    ),
      );

  }
}