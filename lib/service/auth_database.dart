// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/mailbox_model.dart';
import 'package:alternate_store/model/user_model.dart';
import 'package:alternate_store/model/usercoupon_model.dart';

class AuthDatabase {

  final String uid;
  AuthDatabase(this.uid);

  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  //  讀取用戶資料
  Stream<UserModel> get userInformation {
    if (uid.isNotEmpty) {
      return _mFirestore
          .collection('user')
          .doc(uid)
          .snapshots()
          .map((list) => UserModel.fromFirestore(list.data()));
    }
    return null;
  }

  //  新增用戶資料 (用於新登記用戶)
  Future<void> createUserInfo(UserModel userinfo) async {
    try {

      DocumentReference ref = FirebaseFirestore.instance.collection('user').doc(uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(ref);
        if (!snapshot.exists) {
          ref.set({
            'LAST_MODIFY': userinfo.lastModify,
            'UID': uid,
            'EMAIL': userinfo.email,
            'USERNAME': userinfo.name,
            'CONTACT': userinfo.contactNo,
            'UNIT_AND_BUILDING': userinfo.unitAndBuilding,
            'ESTATE': userinfo.estate,
            'DISTRICT': userinfo.district,
            'PHOTO': userinfo.userPhoto,
            'RECIPIENT_NAME' : userinfo.recipientName
          });
          
        }
      });

      // //  Setup null order
      // DocumentReference orderref = FirebaseFirestore.instance
      //     .collection('user')
      //     .doc(uid)
      //     .collection('order')
      //     .doc();
      // orderref.set({});
          
      // //  Setup null refund
      // DocumentReference rufundref = FirebaseFirestore.instance
      //     .collection('user')
      //     .doc(uid)
      //     .collection('refund')
      //     .doc();
      // rufundref.set({});

      //  Setup new Mailbox
      String mailboxDocid = FirebaseFirestore.instance.collection('user').doc().id;
      DocumentReference mailboxref = FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('mailbox')
          .doc(mailboxDocid);
      
      mailboxref.set({
        'CREATE_DATE': Timestamp.now(),
        'TITLE' : welcomeMailboxTitle,
        'CONTENT': welcometMailboxContent,
        'ISREADED': false,
        'DOCID' : mailboxDocid
      });

      
    } catch (e) {
      // ignore: avoid_print
      print(e.toString);
    }
  }

  //  更新用戶資料
  Future updateUserInfo(UserModel model) {
    //String zuid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance.collection('user').doc(uid).update({
      'USERNAME': model.name,
      'CONTACT': model.contactNo,
      'RECIPIENT_NAME': model.recipientName,
      'UNIT_AND_BUILDING': model.unitAndBuilding,
      'ESTATE': model.estate,
      'DISTRICT': model.district,
    });
  }

  //  更新用戶頭像
  Future<void> setUserPhoto(String url) async {
    return FirebaseFirestore.instance.collection('user').doc(uid).update({
      'IMAGE' : url
    });
  }

/*
******************************************************************************
******************************************************************************
******************************************************************************
*/

  //  讀取用戶郵箱內所有郵件
  // ignore: missing_return
  Stream<List<MailBoxModel>> getmaillist() {
    if (uid.isNotEmpty) {
      return _mFirestore
        .collection('user')
        .doc(uid)
        .collection('mailbox')
        .snapshots()
        .map((list) => list.docs
        .map((doc) => MailBoxModel.fromFirestore(doc.data(), doc.id)).toList());
    }
  }

  int getUnReadMail(List mailboxData){
    int unReadMail = 0;
    if(mailboxData != null){
      for (var element in mailboxData) {
        if(element.isReaded == false){
          unReadMail++;
        }
      }
    }
    return unReadMail;
  }

  //  移除用戶郵件
  removeMailboxItem(String docId) {
    _mFirestore
        .collection('user')
        .doc(uid)
        .collection('mailbox')
        .doc(docId)
        .delete();
  }

  //  標記用戶已讀取郵件
  readedMailBox(String mailboxDocid){
    DocumentReference mailboxref = FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('mailbox')
          .doc(mailboxDocid);

    return mailboxref.update({
      'ISREADED': true,
    });
  }

/*
******************************************************************************
******************************************************************************
******************************************************************************
*/

  // ignore: missing_return
  Stream<List<UserCouponModel>> getUserCouponRecord(){
    if(uid.isNotEmpty){
      return _mFirestore
        .collection('user')
        .doc(uid)
        .collection('coupon')
        .snapshots()
        .map((list) => list.docs
        .map((doc) => UserCouponModel.fromFirestore(doc.data())).toList());
    }
  }

  addCouponRecord(String couponCode){
    return FirebaseFirestore.instance.collection('user').doc(uid).collection('coupon').doc().set({
      'DATE': Timestamp.now(),
      'CODE' : couponCode
    });
  }

}
