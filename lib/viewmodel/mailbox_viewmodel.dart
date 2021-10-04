// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:alternate_store/model/mailbox_model.dart';
import 'package:alternate_store/screens/mailbox/mailbox_content.dart';
import 'package:alternate_store/service/auth_database.dart';

class MailboxViewModel extends ChangeNotifier{
  
  final SlidableController slidableController = SlidableController();

  //  開啟郵件
  void openMail(BuildContext context, String userId, MailBoxModel mailBoxModel){

    final slidable = Slidable.of(context);
    slidable!.open(actionType: SlideActionType.primary);

    if(mailBoxModel.isReaded == false){
      AuthDatabase(userId).readedMailBox(mailBoxModel.docId);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => MailboxContent(mailBoxModel: mailBoxModel)));
  }

  //  刪除信件
  Future<void> removeItem(String userUid, String docId) async {
    await AuthDatabase(userUid).removeMailboxItem(docId);
  }
  
}