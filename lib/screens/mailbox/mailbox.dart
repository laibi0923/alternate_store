// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:alternate_store/constants.dart';
import 'package:alternate_store/model/mailbox_model.dart';
import 'package:alternate_store/service/auth_services.dart';
import 'package:alternate_store/viewmodel/mailbox_viewmodel.dart';
import 'package:alternate_store/widgets/mailbox/empty_mailboxview.dart';
import 'package:alternate_store/widgets/mailbox/emptyuser_mailboxview.dart';
import 'package:alternate_store/widgets/mailbox/mailbox_itemview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class Mailbox extends StatefulWidget {
  const Mailbox({ Key? key}) : super(key: key);

  @override
  State<Mailbox> createState() => _MailboxState();
}

class _MailboxState extends State<Mailbox> {

  @override
  Widget build(BuildContext context) {
   
    final authService = Provider.of<AuthService>(context);
    final mailboxData = Provider.of<List<MailBoxModel>>(context);
    final _mailboxviewmodel = Provider.of<MailboxViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text('通知')
        ),
      ),
      body: authService.userUid.isEmpty ? emptyUserMailBoxView(context) :
      
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: mailboxData.isEmpty ? emptyMailBoxScreen() :
        ListView.builder(
          itemCount: mailboxData.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index){

            return Slidable(
              key: Key(mailboxData[index].docId),
              controller: _mailboxviewmodel.slidableController,
              actionPane: const SlidableScrollActionPane(),
              secondaryActions: [
                GestureDetector(
                  onTap: () => _mailboxviewmodel.removeItem(authService.userUid, mailboxData[index].docId),
                  child: Container(
                    color: const Color(cPink),
                    margin: const EdgeInsets.only(top: 0, bottom: 15),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.delete, color: Colors.white),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              '刪除', 
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ),
              ],
              child: Builder(
                builder: (context){
                  return GestureDetector(
                    onTap: () => _mailboxviewmodel.openMail(context, authService.userUid, mailboxData[index]),
                    child: mailboxItemView(
                      mailboxData[index].createDate,
                      mailboxData[index].title,
                      mailboxData[index].content,
                      mailboxData[index].isReaded
                    ),
                  );
                }
              )
            );

          }
        )
      ),
    
    );
  }
}