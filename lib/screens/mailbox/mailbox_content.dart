import 'package:alternate_store/constants.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store/model/mailbox_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MailboxContent extends StatelessWidget {
  final MailBoxModel mailBoxModel;

  const MailboxContent({Key? key, required this.mailBoxModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close)
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                mailBoxModel.title,
                style: const TextStyle(fontSize: xTextSize18, fontWeight: FontWeight.bold),
              ),
            ),

            Text(
              mailBoxModel.content,
              style: const TextStyle(height: 1.2),
            )

          ],
        ),
      ),
    );
  }
}