import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';

Widget textFelidDialog(BuildContext context, String title, String hints){

  TextEditingController _textEditingController = TextEditingController();

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17)
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      //padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 20, bottom:20),
            child: Text(
              title,
              style: const TextStyle(fontSize: xTextSize18, fontWeight: FontWeight.bold),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(top: 10, bottom:20),
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration(
                enabledBorder:  const OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                ),
                focusedBorder:  const OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                ),
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
                hintText: hints,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: xTextSize14)
              ),
            ),
          ),
          
          Row(
            children: [

              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, _textEditingController.text), 
                  child: Container(
                    height: 40,
                    color: Colors.transparent,
                    child: const Center(
                      child: Text(
                        '輸入',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context), 
                  child: Container(
                    height: 40,
                    color: Colors.transparent,
                    child: const Center(
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                  )
              ),

            ],
          )

        ],
      ),
    ),
  );
  
}