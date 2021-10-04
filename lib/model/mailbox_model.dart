// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class MailBoxModel {
  final Timestamp createDate;
  final String title;
  final String content;
  final bool isReaded;
  final String docId;

  MailBoxModel(this.createDate, this.content, this.isReaded, this.docId, this.title);

  factory MailBoxModel.initialData() {
    return MailBoxModel(Timestamp.now(), '', false, '', '');
  }

  MailBoxModel.fromFirestore(Map<String, dynamic> dataMap, String docid) :
    createDate = dataMap['CREATE_DATE'],
    title = dataMap['TITLE'],
    content = dataMap['CONTENT'],
    isReaded = dataMap['ISREADED'],
    docId = dataMap['DOCID'];
}
