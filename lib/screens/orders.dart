import 'package:durub/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authSnapshot.hasError) {
            return Center(
              child: Text(
                'خطأ في استرداد بيانات المستخدم',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final currentUser = authSnapshot.data;
          if (currentUser == null) {
            return const Center(child: Text('الرجاء تسجيل الدخول لعرض الطلبات'));
          }

          return _buildOrdersList(currentUser.uid);
        },
      ),
    );
  }

  Widget _buildOrdersList(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('userId', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'حدث خطأ أثناء تحميل الطلبات',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        final orders = snapshot.data?.docs ?? [];
        if (orders.isEmpty) {
          return const Center(child: Text('لا توجد طلبات حالية'));
        }

        return ListView.separated(
          itemCount: orders.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final order = orders[index];
            return _buildOrderTile(order);
          },
        );
      },
    );
  }

  Widget _buildOrderTile(QueryDocumentSnapshot order) {
    final orderData = order.data() as Map<String, dynamic>;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          orderData['رقم الطلب'].toString().substring(0, 2),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        'رقم الطلب: ${orderData['رقم الطلب']}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'السعر: ${orderData['السعر']} دينار',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _navigateToDetails(order),
    );
  }

  void _navigateToDetails(QueryDocumentSnapshot order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(orderData: order),
      ),
    );
  }
}