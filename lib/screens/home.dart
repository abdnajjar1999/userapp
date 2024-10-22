import 'package:durub/screens/orders.dart';
import 'package:durub/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durub/widget/buildtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homescreen extends StatefulWidget {
  static const screenRoute = '/home';

  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(); // Added phone controller
final TextEditingController googleMapLinkController = TextEditingController(); // Added Google Map link controller

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? username;
  String? profileImageUrl;
  double a = 0.0;

  // Function to get the username and image URL from Firestore
  Future<void> _getUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        setState(() {
          username = userData != null && userData.containsKey('username')
              ? userData['username']
              : 'Guest User';
        });

        // Fetch profile image URL using getUserProfileImage method
        String? imageUrl = await getUserProfileImage();
        setState(() {
          profileImageUrl = imageUrl ?? 'https://via.placeholder.com/150'; // Placeholder if image is not found
        });
      }
    }
  }

  Future<String?> getUserProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        String? profileImageUrl = userDoc.data()?['profileImage'];
        return profileImageUrl;
      }
    }
    return null;
  }

  // Function to save order to Firestore
  Future<void> saveOrder() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Convert price to double
        double? price = double.tryParse(priceController.text);

        if (price == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid price')),
          );
          return; // Exit the function if price is invalid
        }

await _firestore.collection('orders').add({
  'رقم الطلب': orderNumberController.text,
  'اسم العميل': customerNameController.text,
  'المنطقة': regionController.text,
  'السعر': price,
  'مواصفات الطلب': descriptionController.text,
  'الملاحظات': notesController.text,
  'رقم الهاتف': phoneController.text,
  'رابط خريطة جوجل': googleMapLinkController.text, // Save Google Map link
  'userId': currentUser.uid,
  'profileImageUrl': profileImageUrl,
  'status': 'null',
  'username': username,
  'deliveryCost': a ?? 0.0,
  'timestamp': FieldValue.serverTimestamp(),
});

        // Clear the form after saving
        orderNumberController.clear();
        customerNameController.clear();
        regionController.clear();
        priceController.clear();
        descriptionController.clear();
        notesController.clear();
        phoneController.clear(); // Clear phone field

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save order: $e')),
      );
    }
  }

  // Function to handle logout
  Future<void> logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data when screen initializes
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
          ),
        ],
        centerTitle: true,
        title: const Text('إنشاء طلب', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                username ?? 'Guest User',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                _auth.currentUser?.email ?? '',
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  profileImageUrl ?? 'https://via.placeholder.com/150',
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                image: const DecorationImage(
                  image: NetworkImage('https://source.unsplash.com/random/?city,night'),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('About Us'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Your App Name',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.info_outline),
                  children: [
                    const Text('This app is designed to help you manage orders seamlessly.'),
                  ],
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'تفاصيل الطلب',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
_buildFormField(
  width, 
  'رقم الطلب', 
  Icons.assignment_outlined, 
  orderNumberController, 
  keyboardType: TextInputType.number, // Numeric keyboard for order number
),
_buildFormField(
  width, 
  'اسم العميل', 
  Icons.person_outline, 
  customerNameController, 
  keyboardType: TextInputType.text, // Text keyboard for customer name
),
_buildFormField(
  width, 
  'المنطقة', 
  Icons.location_on_outlined, 
  regionController, 
  keyboardType: TextInputType.text, // Text keyboard for region
),
_buildFormField(
  width, 
  'رقم الهاتف', 
  Icons.phone_outlined, 
  phoneController, 
  keyboardType: TextInputType.phone, // Phone keyboard for phone number
),
_buildFormField(
  width, 
  'السعر', 
  Icons.attach_money_outlined, 
  priceController, 
  keyboardType: TextInputType.numberWithOptions(decimal: true), // Numeric keyboard for price, with decimal support
),
_buildFormField(
  width, 
  'رابط خريطة جوجل', 
  Icons.link_outlined, 
  googleMapLinkController, 
  keyboardType: TextInputType.url, // URL keyboard for Google Maps link
),
_buildFormField(
  width, 
  'مواصفات الطلب', 
  Icons.description_outlined, 
  descriptionController, 
  maxLines: 2, 
  keyboardType: TextInputType.multiline, // Multiline keyboard for description
),
_buildFormField(
  width, 
  'الملاحظات', 
  Icons.notes_outlined, 
  notesController, 
  maxLines: 4, 
  keyboardType: TextInputType.multiline, // Multiline keyboard for notes
),
                          ButtonWidget(
                            width: width,
                            callBack: saveOrder,
                            buttonText: 'احفظ الطلب',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

Widget _buildFormField(
  double width,
  String label,
  IconData icon,
  TextEditingController controller, {
  int maxLines = 1,
  TextInputType? keyboardType, // Accept keyboardType as an optional parameter
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: AnimatedBuildTextFormField(
      keyboardType: keyboardType ?? TextInputType.text, // Use the provided keyboardType, default to text
      width: width,
      hintText: label,
      iconData: icon,
      label: 'ادخل $label',
      controller: controller,
      maxLines: maxLines,
    ),
  );
}
}