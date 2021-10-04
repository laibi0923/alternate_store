// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';

getCustomFormattedDateTime(Timestamp timestamp) {
    return DateFormat('dd/MM/yyy kk:mm').format(timestamp.toDate());
}

Widget mailboxItemView(Timestamp createDate, String title, String content, bool isReaded){
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
    decoration: const BoxDecoration(
      color: Color(cGrey),
      borderRadius: BorderRadius.all(Radius.circular(7))
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Expanded(
                child:  Text(
                  getCustomFormattedDateTime(createDate),
                  style: const TextStyle(
                    //fontSize: xTextSize14,
                    fontWeight: FontWeight.bold
                  )
                )
              ),
              
              isReaded == true ? Container() :
              Container(
                height: 13,
                width: 13,
                decoration: const BoxDecoration(
                  color: Color(cPink),
                  borderRadius: BorderRadius.all(Radius.circular(99))
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: xTextSize16, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),

        Text(
          content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: xTextSize14),
        )
      ],
    ),
  );
}
