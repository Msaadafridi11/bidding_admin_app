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
  late Future<QuerySnapshot> _carListFuture;
  @override
  void initState() {
    super.initState();
    _carListFuture = FirebaseFirestore.instance.collection('itemModel').get();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Admin Car Lists Screen'),
      ),
     body: FutureBuilder<QuerySnapshot>(future: _carListFuture, builder: (context, snapshot) {
       if(snapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
       }
       if(snapshot.hasError){
        return Center(child: Text('Error: ${snapshot.error}'),);
       }
       if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
        return Center(child: Text('No Data Found'),);
       }
         return Expanded(
         child: ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
           final itemData=ItemModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
           return Card(
             child: GestureDetector(
               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Adminadddata(item: itemData,),)),
              child: Customlisttile(
              title: Text('Car Name: ${itemData.title.toString()}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('car price: ${itemData.sellerPrice.toString()} ||  car model: ${itemData.model}'),
                  Text('car active: ${itemData.isActive.toString()}'),
                  Text('car created: ${itemData.createdAt}'),
                ],
              ),                
             ),
             ),
              );
         },),
       );
     },),
    );
  }
}