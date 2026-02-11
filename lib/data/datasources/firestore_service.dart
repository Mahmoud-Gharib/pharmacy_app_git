import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Orders Collection
  CollectionReference get ordersCollection => _firestore.collection('orders');
  
  // Medicines Collection
  CollectionReference get medicinesCollection => _firestore.collection('medicines');
  
  // Customers Collection
  CollectionReference get customersCollection => _firestore.collection('customers');

  // Order Methods
  Future<List<Map<String, dynamic>>> getOrders({String? status}) async {
    Query query = ordersCollection.orderBy('createdAt', descending: true);
    
    if (status != null && status != 'all') {
      query = query.where('status', isEqualTo: status);
    }
    
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Stream<List<Map<String, dynamic>>> getOrdersStream({String? status}) {
    Query query = ordersCollection.orderBy('createdAt', descending: true);
    
    if (status != null && status != 'all') {
      query = query.where('status', isEqualTo: status);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    final doc = await ordersCollection.doc(orderId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }
    return null;
  }

  Future<String> createOrder(Map<String, dynamic> orderData) async {
    orderData['createdAt'] = FieldValue.serverTimestamp();
    orderData['updatedAt'] = FieldValue.serverTimestamp();
    final docRef = await ordersCollection.add(orderData);
    return docRef.id;
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> orderData) async {
    orderData['updatedAt'] = FieldValue.serverTimestamp();
    await ordersCollection.doc(orderId).update(orderData);
  }

  Future<void> deleteOrder(String orderId) async {
    await ordersCollection.doc(orderId).delete();
  }

  // Medicine Methods
  Future<List<Map<String, dynamic>>> getMedicines({bool? lowStock}) async {
    Query query = medicinesCollection.orderBy('name');
    
    if (lowStock == true) {
      query = query.where('quantity', isLessThanOrEqualTo: 10);
    }
    
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<String> addMedicine(Map<String, dynamic> medicineData) async {
    medicineData['createdAt'] = FieldValue.serverTimestamp();
    final docRef = await medicinesCollection.add(medicineData);
    return docRef.id;
  }

  Future<void> updateMedicine(String medicineId, Map<String, dynamic> medicineData) async {
    medicineData['updatedAt'] = FieldValue.serverTimestamp();
    await medicinesCollection.doc(medicineId).update(medicineData);
  }

  // Dashboard Stats
  Future<Map<String, int>> getDashboardStats() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    final ordersSnapshot = await ordersCollection
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .get();
    
    final lowStockSnapshot = await medicinesCollection
        .where('quantity', isLessThanOrEqualTo: 10)
        .get();
    
    final expiringSnapshot = await medicinesCollection
        .where('expiryDate', isLessThanOrEqualTo: Timestamp.fromDate(today.add(const Duration(days: 30))))
        .get();

    return {
      'todayOrders': ordersSnapshot.docs.length,
      'lowStock': lowStockSnapshot.docs.length,
      'expiringSoon': expiringSnapshot.docs.length,
    };
  }
}
