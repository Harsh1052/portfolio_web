import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/firebase_service.dart';
import '../models/portfolio_content.dart';

/// Reads the single `content/portfolio` Firestore document.
/// Calls [FirebaseService.ensureInitialized] before any Firestore access
/// to keep Firebase off the critical path of the initial render.
class ContentRemoteSource {
  const ContentRemoteSource(this._firebaseService);

  final FirebaseService _firebaseService;

  Future<PortfolioContent> getContent() async {
    await _firebaseService.ensureInitialized();
    if (!_firebaseService.isInitialized) {
      throw Exception('Firebase unavailable — cannot fetch portfolio content.');
    }
    final doc = await FirebaseFirestore.instance
        .collection('content')
        .doc('portfolio')
        .get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Portfolio content document not found in Firestore.');
    }
    return PortfolioContent.fromMap(doc.data()!);
  }
}
