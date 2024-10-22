import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durub/widget/buildtextformfield.dart'; // Import your custom BuildTextFormField widget

class DetailsScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> orderData;

  const DetailsScreen({super.key, required this.orderData});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController orderNumberController;
  late TextEditingController customerNameController;
  late TextEditingController regionController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController notesController;
  late TextEditingController phoneController; // Added phone controller

  @override
  void initState() {
    super.initState();

    // Initialize controllers with order data
    orderNumberController = TextEditingController(text: widget.orderData['رقم الطلب'].toString());
    customerNameController = TextEditingController(text: widget.orderData['اسم العميل']);
    regionController = TextEditingController(text: widget.orderData['المنطقة']);
    
    // Convert double to String for priceController
    priceController = TextEditingController(text: widget.orderData['السعر'].toString());

    descriptionController = TextEditingController(text: widget.orderData['مواصفات الطلب']);
    notesController = TextEditingController(text: widget.orderData['الملاحظات']);
    phoneController = TextEditingController(text: widget.orderData['رقم الهاتف']); // Initialize phone number
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // رقم الطلب
                AnimatedBuildTextFormField(
                  keyboardType: TextInputType.number,
                  width: width,
                  hintText: 'رقم الطلب',
                  iconData: Icons.assignment_outlined,
                  label: 'ادخل رقم الطلب',
                  controller: orderNumberController,
                ),
                const SizedBox(height: 10),

                // اسم العميل
                AnimatedBuildTextFormField(
                  keyboardType: TextInputType.text,
                  width: width,
                  hintText: 'اسم العميل',
                  iconData: Icons.person_outline,
                  label: 'ادخل اسم العميل',
                  controller: customerNameController,
                ),
                const SizedBox(height: 10),

                // المنطقة
                AnimatedBuildTextFormField(
                  keyboardType: TextInputType.text,
                  width: width,
                  hintText: 'المنطقة',
                  iconData: Icons.location_on_outlined,
                  label: 'ادخل المنطقة',
                  controller: regionController,
                ),
                const SizedBox(height: 10),

                // السعر
                AnimatedBuildTextFormField(
                  keyboardType: TextInputType.number,
                  width: width,
                  hintText: 'السعر',
                  iconData: Icons.attach_money_outlined,
                  label: 'ادخل السعر',
                  controller: priceController,
                ),
                const SizedBox(height: 10),

                // رقم الهاتف
                AnimatedBuildTextFormField(
                  keyboardType: TextInputType.phone,
                  width: width,
                  hintText: 'رقم الهاتف',
                  iconData: Icons.phone_outlined,
                  label: 'ادخل رقم الهاتف',
                  controller: phoneController, // Use the same controller for phone
                ),
                const SizedBox(height: 10),

                // مواصفات الطلب
                AnimatedBuildTextFormField(
                  keyboardType: TextInputType.text,
                  width: width,
                  hintText: 'مواصفات الطلب',
                  iconData: Icons.description_outlined,
                  label: 'ادخل مواصفات الطلب',
                  controller: descriptionController,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),

                // الملاحظات
                AnimatedBuildTextFormField(
                  keyboardType: TextInputType.text,
                  width: width,
                  hintText: 'الملاحظات',
                  iconData: Icons.notes_outlined,
                  label: 'ادخل الملاحظات',
                  controller: notesController,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
