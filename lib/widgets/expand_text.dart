import 'package:flutter/material.dart';

class ExpandText extends StatefulWidget {
  final String content;
  const ExpandText({ Key? key, required this.content }) : super(key: key);

  @override
  _ExpandTextState createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {

  bool _isExpanedText = false;

  void _toggleExpandText(){
    if(_isExpanedText){
      setState(() {
        _isExpanedText = false;
      });
    } else{
      setState(() {
        _isExpanedText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            widget.content,
            maxLines: _isExpanedText ? 999 : 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, height: 1.5)
          ),

          GestureDetector(
            onTap: () => _toggleExpandText(),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: _isExpanedText ? 
              const Text(
                '收起',
                style: TextStyle(color: Colors.grey),
              ) : 
              const Text(
                '更多',
                style: TextStyle(color: Colors.grey),
              ),
            )
          )


        ],
      ),
    );
  }
}