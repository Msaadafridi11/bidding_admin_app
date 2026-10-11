import 'dart:io';

import 'package:bidding_admin/Models/item_model.dart';
import 'package:bidding_admin/Screens/BottemNevigationScreen.dart';
import 'package:bidding_admin/WidgetsScreen/CustomTextFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Adminadddata extends StatefulWidget {
  const Adminadddata({
    super.key,
    this.item,
  });
  final ItemModel? item;

  @override
  State<Adminadddata> createState() => _AdminadddataState();
}

class _AdminadddataState extends State<Adminadddata> {
  bool isSaving = false;
  bool isUpdating = false;
  bool isDeleting = false;

  final _formKey = GlobalKey<FormState>();
  List<File> _images = [];
  List<String> existingImageUrls = [];
  

  // PICK MULTIPLE IMAGES
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _images.addAll(
          images.map((x) => File(x.path)).toList(),
        );
      });
    }
  }


  //dialog function
  Future<void> _showconfirmDialog(
      {required String title,
      required BuildContext context,
      required String message,
      required VoidCallback onConfirm}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Call the confirm callback
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  //this function for save
  Future<void> _saveCar() async {
    setState(() => isSaving = true);

    try {
      final itemId =
          FirebaseFirestore.instance.collection('itemModel').doc().id;

      //  Upload images FIRST
      List<String> uploadedImageUrls = [];

      for (int i = 0; i < _images.length; i++) {
        final image = _images[i];

        final fileName = '${DateTime.now().microsecondsSinceEpoch}_$i.jpg';
        final path = 'uploads/$fileName';

        await Supabase.instance.client.storage
            .from('images')
            .upload(path, image);

        final url =
            Supabase.instance.client.storage.from('images').getPublicUrl(path);

        uploadedImageUrls.add(url);
      }

      //  Now create model WITH imageUrls
      final data = ItemModel(
        itemId: itemId,
        imageUrls: uploadedImageUrls,
        
        title: _titleController.text,
        description: _descriptionController.text,
        model: _modelController.text,
        make: _makeController.text,
        year: int.tryParse(_yearController.text),
        mileage: int.tryParse(_mileageController.text),
        sellerPrice: double.tryParse(_sellerPriceController.text),
        minimumBid: double.tryParse(_minimumBidController.text),
        isActive: _isActive,
        bidEndTime: _selectedBidEndTime,
        currentBid: double.tryParse(_minimumBidController.text) ?? 0.0,
        createdAt: DateTime.now(),
      );

      //  Save to Firestore AFTER uploads
      await FirebaseFirestore.instance
          .collection('itemModel')
          .doc(itemId)
          .set(data.toJson());


      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data added successfully')),
        );

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const Bottemnevigationscreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  

  //this function for update/edit
  Future<void> _updateCar() async {
  if (widget.item == null || widget.item!.itemId == null) return;

  setState(() => isUpdating = true);

  try {
    
        List<String> finalImageUrls = List.from(existingImageUrls);
   

    // 🔹 Upload NEW images (_images)
    for (final image in _images) {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final path = 'uploads/$fileName.jpg';

      await Supabase.instance.client.storage
          .from('images')
          .upload(path, image);

      final url = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(path);

      finalImageUrls.add(url);
    

    }

  
    await FirebaseFirestore.instance
        .collection('itemModel')
        .doc(widget.item!.itemId)
        .update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'model': _modelController.text,
      'make': _makeController.text,
      'year': int.tryParse(_yearController.text),
      'mileage': int.tryParse(_mileageController.text),
      'registeredIn': _registeredInController.text,
      'bodyType': _bodyTypeController.text,
      'engineSize': _engineSizeController.text,
      'enteriorColor': _enteriorColorController.text,
      'exteriorColor': _exteriorColorController.text,
      'firstOwner': _firstOwnerController.text,
      'fuelType': _fuelTypeController.text,
      'safetyBeltStatus': _safetyBeltController.text,
      'specification': _specificationController.text,
      'transmission': _transmissionController.text,
      'trim': _trimController.text,
      'carOptions': _carOptionsController.text,
      'keys': int.tryParse(_keysController.text),
      'numberOfCylinders':
          int.tryParse(_numberOfCylindersController.text),
      'wheelType': _wheelTypeController.text,
      'interiorType': _interiorTypeController.text,
      'exteriorCondition': _exteriorConditionController.text,
      'steeringCondition': _steeringConditionController.text,
      'interiorCondition': _interiorConditionController.text,
      'isActive': _isActive,
      'imageUrls': finalImageUrls,
      
    });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car updated successfully')),
        );

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Bottemnevigationscreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      _images.clear();
      if (mounted) {
        setState(() => isUpdating = false);
      }
    }
}

String _getSupabasePathFromUrl(String url) {
  final uri = Uri.parse(url);
  return uri.pathSegments.skipWhile((e) => e != 'uploads').join('/');
}
  // this is for delete Button
 Future<void> _deleteCar() async {
  if (widget.item == null || widget.item!.itemId == null) return;

  setState(() => isDeleting = true);

  try {
    /// 1️⃣ DELETE IMAGES FROM SUPABASE
    final List<String> imageUrls = widget.item!.imageUrls ?? [];

    if (imageUrls.isNotEmpty) {
      final List<String> pathsToDelete = imageUrls
          .map((url) => _getSupabasePathFromUrl(url))
          .toList();

      await Supabase.instance.client.storage
          .from('images')
          .remove(pathsToDelete);
    }

    ///  DELETE FIRESTORE DOCUMENT
    await FirebaseFirestore.instance
        .collection('itemModel')
        .doc(widget.item!.itemId)
        .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car deleted successfully')),
        );

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Bottemnevigationscreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isDeleting = false);
      }
    }
}


  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      // If an item is provided, populate the controllers with its data
       existingImageUrls = List.from(widget.item!.imageUrls ?? []);            //for images
      

      _titleController.text = widget.item!.title ?? '';
      _descriptionController.text = widget.item!.description ?? '';
      _modelController.text = widget.item!.model ?? '';
      _makeController.text = widget.item!.make ?? '';
      _yearController.text = widget.item!.year.toString();
      _mileageController.text = widget.item!.mileage.toString();
      _registeredInController.text = widget.item!.registeredIn ?? '';
      _bodyTypeController.text = widget.item!.bodyType ?? '';
      _engineSizeController.text = widget.item!.engineSize ?? '';
      _enteriorColorController.text = widget.item!.enteriorColor ?? '';
      _exteriorColorController.text = widget.item!.exteriorColor ?? '';
      _firstOwnerController.text = widget.item!.firstOwner ?? '';
      _fuelTypeController.text = widget.item!.fuelType ?? '';
      _safetyBeltController.text = widget.item!.safetyBeltStatus ?? '';
      _specificationController.text = widget.item!.specification ?? '';
      _transmissionController.text = widget.item!.transmission ?? '';
      _trimController.text = widget.item!.trim ?? '';
      _carOptionsController.text = widget.item!.carOptions ?? '';
      _keysController.text = widget.item!.keys.toString();
      _numberOfCylindersController.text =
          widget.item!.numberOfCylinders.toString();
      _wheelTypeController.text = widget.item!.wheelType ?? '';
      _interiorTypeController.text = widget.item!.interiorType ?? '';
      _exteriorConditionController.text = widget.item!.exteriorCondition ?? '';
      _steeringConditionController.text = widget.item!.steering ?? '';
      _interiorConditionController.text = widget.item!.interior ?? '';
      _specsController.text = widget.item!.specs ?? '';
      _historyController.text = widget.item!.history ?? '';
      _wheelsController.text = widget.item!.wheels ?? '';
      // Bidding part
      _sellerPriceController.text = widget.item!.sellerPrice?.toString() ?? '';
      _minimumBidController.text = widget.item!.minimumBid?.toString() ?? '';
      _selectedBidEndTime = widget.item!.bidEndTime;
      _isActive = widget.item!.isActive ?? true;
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _modelController = TextEditingController();
  final _makeController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  final _registeredInController = TextEditingController();
  final _bodyTypeController = TextEditingController();
  final _engineSizeController = TextEditingController();
  final _enteriorColorController = TextEditingController();
  final _exteriorColorController = TextEditingController();
  final _firstOwnerController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _safetyBeltController = TextEditingController();
  final _specificationController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _trimController = TextEditingController();
  final _carOptionsController = TextEditingController();
  final _keysController = TextEditingController();
  final _numberOfCylindersController = TextEditingController();
  final _wheelTypeController = TextEditingController();
  final _interiorTypeController = TextEditingController();
  final _exteriorConditionController = TextEditingController();
  final _steeringConditionController = TextEditingController();
  final _interiorConditionController = TextEditingController();
  final _specsController = TextEditingController();
  final _historyController = TextEditingController();
  final _wheelsController = TextEditingController();
  //this controller use for bidding part
  final _sellerPriceController = TextEditingController();
  final _minimumBidController = TextEditingController();
  DateTime? _selectedBidEndTime;
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
  height: 120,
  child: (existingImageUrls.isEmpty && _images.isEmpty)
      // PLACEHOLDER
      ? Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.image_outlined, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text('Select Car Images',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        )

      // IMAGES LIST
      : ListView(
          scrollDirection: Axis.horizontal,
          children: [

            // EXISTING IMAGES (URLs)
            ...existingImageUrls.map((url) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            existingImageUrls.remove(url);
                          });
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            //  NEW PICKED IMAGES (File)
            ..._images.map((file) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        file,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.remove(file);
                          });
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
),

                    const SizedBox(height: 20),

                    // Pick Image Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: pickImages,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Pick Image'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      height: 30,
                    ),

                    Center(
                        child: Text(
                      'Add car Title here',
                      style: GoogleFonts.aDLaMDisplay(fontSize: 20),
                    )),
                    // this TextFormField for title
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                          child: Custemtextformfield(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        //title Controller
                        controller: _titleController,
                        hintText: ' Enter title here',
                        maxLines: 1,
                        hintStyle: TextStyle(color: Colors.grey),
                        readOnly: false,
                        filled: true,
                        fillColor: Colors.white,
                        label: Text('Title'),
                      )),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Center(
                        child: Text(
                      'Add car description here',
                      style: GoogleFonts.aDLaMDisplay(fontSize: 20),
                    )),
                    // this TextFormField for description
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                          child: Custemtextformfield(
                        // description Controller
                        controller: _descriptionController,
                        hintText: ' Enter description here',
                        maxLines: 3,
                        hintStyle: TextStyle(color: Colors.grey),
                        readOnly: false,
                        filled: true,
                        fillColor: Colors.white,
                        label: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text('Description'),
                        ),
                      )),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Center(
                        child: Text(
                      'Add car specs here',
                      style: GoogleFonts.aDLaMDisplay(fontSize: 20),
                    )),
                    // this TextFormField for specs
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                          child: Custemtextformfield(
                        // specs Controller
                        controller: _specsController,
                        hintText: ' Enter specs here',
                        maxLines: 3,
                        hintStyle: TextStyle(color: Colors.grey),
                        readOnly: false,
                        filled: true,
                        fillColor: Colors.white,
                        label: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text('Specs'),
                        ),
                      )),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Center(
                        child: Text(
                      'Add car History here',
                      style: GoogleFonts.aDLaMDisplay(fontSize: 20),
                    )),
                    // this TextFormField for history
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                          child: Custemtextformfield(
                        // history Controller
                        controller: _historyController,
                        hintText: ' Enter history here',
                        maxLines: 3,
                        hintStyle: TextStyle(color: Colors.grey),
                        readOnly: false,
                        filled: true,
                        fillColor: Colors.white,
                        label: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text('History'),
                        ),
                      )),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Center(
                        child: Text(
                      'Add car wheels here',
                      style: GoogleFonts.aDLaMDisplay(fontSize: 20),
                    )),
                    // this TextFormField for wheels
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                          child: Custemtextformfield(
                        // wheels Controller
                        controller: _wheelsController,
                        hintText: ' Enter wheels here',
                        maxLines: 3,
                        hintStyle: TextStyle(color: Colors.grey),
                        readOnly: false,
                        filled: true,
                        fillColor: Colors.white,
                        label: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text('wheels'),
                        ),
                      )),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Center(
                        child: Text(
                      'Add car steeringCondition here',
                      style: GoogleFonts.aDLaMDisplay(fontSize: 20),
                    )),
                    // this TextFormField for steeringCondition
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                          child: Custemtextformfield(
                        // steeringCondition Controller
                        controller: _steeringConditionController,
                        hintText: ' Enter steeringCondition here',
                        maxLines: 3,
                        hintStyle: TextStyle(color: Colors.grey),
                        readOnly: false,
                        filled: true,
                        fillColor: Colors.white,
                        label: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text('steeringCondition'),
                        ),
                      )),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Center(
                        child: Text(
                      'Add car exteriorCondition here',
                      style: GoogleFonts.aDLaMDisplay(fontSize: 20),
                    )),
                    // this TextFormField for exteriorCondition
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                          child: Custemtextformfield(
                        // exteriorCondition Controller
                        controller: _exteriorConditionController,
                        hintText: ' Enter exteriorCondition here',
                        maxLines: 3,
                        hintStyle: TextStyle(color: Colors.grey),
                        readOnly: false,
                        filled: true,
                        fillColor: Colors.white,
                        label: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text('ExteriorCondition'),
                        ),
                      )),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Center(
                        child: Text(
                      'Add car interiorCondition here',
                      style: GoogleFonts.aDLaMDisplay(fontSize: 20),
                    )),
                    // this TextFormField for interiorCondition
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                          child: Custemtextformfield(
                        // interiorCondition Controller
                        controller: _interiorConditionController,
                        hintText: ' Enter interiorCondition here',
                        maxLines: 3,
                        hintStyle: TextStyle(color: Colors.grey),
                        readOnly: false,
                        filled: true,
                        fillColor: Colors.white,
                        label: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text('interiorCondition'),
                        ),
                      )),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add car Model here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'Add car Year here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car model
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car model controller
                            controller: _modelController,
                            hintText: ' Enter Model here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('Model'),
                          )),
                        ),
                        // this is for car year
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // year controller
                            controller: _yearController,
                            hintText: ' Enter Year here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('Year'),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add car Make here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'Add car mileage here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car make
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car make controller
                            controller: _makeController,
                            hintText: ' Enter make here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('Make'),
                          )),
                        ),
                        // this is for car mileage
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // mileage controller
                            controller: _mileageController,
                            hintText: ' Enter mileage here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('mileage'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ' registeredIn here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'Add bodyType here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car registeredIn
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car registeredIn controller
                            controller: _registeredInController,
                            hintText: ' Enter registeredIn here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('registeredIn'),
                          )),
                        ),
                        // this is for car body Type
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // body Type controller
                            controller: _bodyTypeController,
                            hintText: ' Enter bodyType here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('BodyType'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add engineSize here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'NumberOfCylinders ',
                          style: GoogleFonts.aDLaMDisplay(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car engineSize
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car engineSize controller
                            controller: _engineSizeController,
                            hintText: ' Enter engineSize here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('EngineSize'),
                          )),
                        ),
                        // this is for car numberOfCylinders
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // numberOfCylinders controller
                            controller: _numberOfCylindersController,
                            hintText: ' Enter numberOfCylinders here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('numberOfCylinders'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add fuelType here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'Transmission here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car fuelType
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car fuelType controller
                            controller: _fuelTypeController,
                            hintText: ' Enter fuelType here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('fuelType'),
                          )),
                        ),
                        // this is for car transmission
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // transmission controller
                            controller: _transmissionController,
                            hintText: ' Enter transmission here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('transmission'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add wheelType here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'Add carOptions here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car wheelType
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car wheelType controller
                            controller: _wheelTypeController,
                            hintText: ' Enter wheelType here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('wheelType'),
                          )),
                        ),
                        // this is for car carOptions
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // carOptions controller
                            controller: _carOptionsController,
                            hintText: ' Enter carOptions here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('carOptions'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add car trim here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'Add interiorType here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car trim
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car trim controller
                            controller: _trimController,
                            hintText: ' Enter trim here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('trim'),
                          )),
                        ),
                        // this is for car interiorType
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // interiorType controller
                            controller: _interiorTypeController,
                            hintText: ' Enter interiorType here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('interiorType'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add car keys here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'Add safetyBelt here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car keys
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car keys controller
                            controller: _keysController,
                            hintText: ' Enter keys here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('keys'),
                          )),
                        ),
                        // this is for car safetyBelt
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // safetyBelt controller
                            controller: _safetyBeltController,
                            hintText: ' Enter safetyBelt here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('safetyBelt'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Specification here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'ExteriorColor here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this for car specification
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car specification controller
                            controller: _specificationController,
                            hintText: ' Enter specification here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('specification'),
                          )),
                        ),
                        // this  for car exteriorColor
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // exteriorColor controller
                            controller: _exteriorColorController,
                            hintText: ' Enter exteriorColor here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('exteriorColor'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EnteriorColor here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                        Text(
                          'Add firstOwner here',
                          style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this is for car enteriorColor
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            //car enteriorColor controller
                            controller: _enteriorColorController,
                            hintText: ' Enter enteriorColor here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('enteriorColor'),
                          )),
                        ),
                        // this is for car firstOwner
                        Container(
                          width: 150,
                          height: 50,
                          child: Center(
                              child: Custemtextformfield(
                            // firstOwner controller
                            controller: _firstOwnerController,
                            hintText: ' Enter firstOwner here',
                            maxLines: 1,
                            hintStyle: TextStyle(color: Colors.grey),
                            readOnly: false,
                            filled: true,
                            fillColor: Colors.white,
                            label: Text('firstOwner'),
                          )),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            'Bidding part here',
                            style: GoogleFonts.acme(fontSize: 20),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'sellerPrice here',
                                style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                              ),
                              Text(
                                'minimumBid here',
                                style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // this for car sellerPrice
                              Container(
                                width: 150,
                                height: 50,
                                child: Center(
                                    child: Custemtextformfield(
                                  //car sellerPrice controller
                                  controller: _sellerPriceController,
                                  hintText: ' Enter sellerPrice here',
                                  maxLines: 1,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  readOnly: false,
                                  filled: true,
                                  fillColor: Colors.white,
                                  label: Text('sellerPrice'),
                                )),
                              ),
                              // this  for car minimumBid
                              Container(
                                width: 150,
                                height: 50,
                                child: Center(
                                    child: Custemtextformfield(
                                  // minimumBid controller
                                  controller: _minimumBidController,
                                  hintText: ' Enter minimumBid here',
                                  maxLines: 1,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  readOnly: false,
                                  filled: true,
                                  fillColor: Colors.white,
                                  label: Text('minimumBid'),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Is Active =>',
                                style: GoogleFonts.aDLaMDisplay(
                                    fontSize: 25, color: Colors.white),
                              ),
                              // this is for on or off button
                              Switch(
                                //_isActive veriable
                                value: _isActive,
                                onChanged: (value) {
                                  setState(() {
                                    _isActive = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Bid End Time',
                            style: GoogleFonts.aDLaMDisplay(fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () async {
                              // Date picker
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate == null) return;
                              if (!mounted) return;

                              // Time picker
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime == null) return;

                              setState(() {
                                _selectedBidEndTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            },
                            child: Text(
                              _selectedBidEndTime == null
                                  ? 'Select Bid End Time'
                                  : _selectedBidEndTime.toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (widget.item == null)
                      GestureDetector(
                        onTap: isSaving
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please fill all required fields')));
                                  return;
                                }
                                if (_selectedBidEndTime == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please select bid end time')));
                                  return;
                                }
                                if (_images.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please select at least one image')));
                                  return;
                                }
                                // we call save function and also diagol
                                await _showconfirmDialog(
                                  title: 'save car',
                                  context: context,
                                  message: 'Are you sure do you want to save',
                                  onConfirm: _saveCar,
                                );
                              },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 69, 16, 104)
                                    .withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                                spreadRadius: 3,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                          ),
                          child: Center(
                            child: isSaving
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Save Car',
                                    style: GoogleFonts.aDLaMDisplay(
                                      color: Colors.white,
                                      fontSize: 18,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                    SizedBox(
                      height: 30,
                    ),
                    // delete Button
                    if (widget.item != null)
                      GestureDetector(
                        onTap: isDeleting
                            ? null
                            : () async {
                                try {
                                  setState(() => isDeleting = true);

                                  // we call delete function and also diagol
                                  await _showconfirmDialog(
                                      title: 'delete car',
                                      context: context,
                                      message:
                                          'Do you want to delete this car ?',
                                      onConfirm: _deleteCar);
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                } finally {
                                  if (mounted) setState(() => isDeleting = false);
                                }
                              },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 69, 16, 104)
                                    .withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                                spreadRadius: 3,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                          ),
                          child: Center(
                            child: isDeleting
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Delete Car',
                                    style: GoogleFonts.aDLaMDisplay(
                                      color: Colors.white,
                                      fontSize: 18,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                    SizedBox(
                      height: 20,
                    ),
                    // uptate/edit Button
                    if (widget.item != null)
                      GestureDetector(
                        onTap: isUpdating
                            ? null
                            : () async {
                                // we call update function and also diagol
                                await _showconfirmDialog(
                                  title: 'update car',
                                  context: context,
                                  message: 'Are you sure do you want to update',
                                  onConfirm: _updateCar,
                                );
                              },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: isUpdating
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Update Car',
                                    style: GoogleFonts.aDLaMDisplay(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
