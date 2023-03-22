import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

class StreamMessagesViewModel extends StreamViewModel<QuerySnapshot<Map<String, dynamic>>> {
  StreamMessagesViewModel({this.chatId,});
  final String? chatId;

  final _fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    return _fireStore
        .collection("chats")
        .doc(chatId).collection("messages")
        .orderBy("createdAt")
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> get stream => getSnapshots();
}