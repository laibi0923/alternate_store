import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store/constants.dart';

class CustomizeDialog extends StatefulWidget {
  final String title;
  final String content;
  final String submitBtnText;
  final String cancelBtnText;
  const CustomizeDialog({ Key? key, required this.title, required this.content, required this.submitBtnText, required this.cancelBtnText }) : super(key: key);

  @override
  _CustomizeDialogState createState() => _CustomizeDialogState();
}

class _CustomizeDialogState extends State<CustomizeDialog> {

  void _submitOnclick(){
    Navigator.pop(context, true);
  }

  void _cancelOnClick(){
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contebtBox(),
    );
  }

  contebtBox() {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold),)
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
            child: Text(widget.content, textAlign: TextAlign.center,)
          ),

          const Divider(color: Colors.grey, height: 1,),

          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _submitOnclick(), 
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                    ),
                    child: Text(
                      widget.submitBtnText,
                      style: const TextStyle(color: Color(cPrimaryColor)),
                    )
                  )
                ),
                const VerticalDivider(color: Colors.grey,),
                Expanded(
                  child: TextButton(
                    onPressed: () => _cancelOnClick(),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                    ),
                    child: Text(
                      widget.cancelBtnText,
                      style: const TextStyle(color: Color(cPink)),
                    ),
                  )
                )
              ],
            ),
          )
        
        ],
      ),
    );
  }

}