import 'package:alternate_store/constants.dart';
import 'package:alternate_store/sflocker_list.dart';
import 'package:flutter/material.dart';

class SFLockerLocation extends StatefulWidget {
  const SFLockerLocation({ Key? key }) : super(key: key);

  @override
  State<SFLockerLocation> createState() => _SFLockerLocationState();
}

class _SFLockerLocationState extends State<SFLockerLocation> {

  final TextEditingController _searchTextController = TextEditingController();
  List<Map<String, String>> _resultList = [];

  void _searchLocation(String queryString){
    if(queryString.trim().isEmpty){
      _resultList.clear();
      _resultList = LockerList().lockerList;
    } else {
      _resultList.clear();
      for(int i = 0; i < LockerList().lockerList.length; i++){
        if(
          LockerList().lockerList[i]['location'].toString().contains(queryString) ||
          LockerList().lockerList[i]['code'].toString().contains(queryString)
        ){
          _resultList.add(LockerList().lockerList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _resultList = LockerList().lockerList;
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSearchAppbar(context),
      body: ListView.builder(
        itemCount: _resultList.length,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
        itemBuilder: (context, index){

          return GestureDetector(
            onTap: () => Navigator.pop(context, _resultList[index]),
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: const Color(cGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _resultList[index]['code'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  Text(
                    _resultList[index]['location'].toString(),
                  ),
                  Container(height: 10),
                  Text(
                    _resultList[index]['openingHour'].toString(),
                  ),
                  
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  AppBar _buildSearchAppbar(BuildContext context){
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Container(
        decoration: const BoxDecoration(
          color: Color(cGrey),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context, {}),
              icon: const Icon(Icons.arrow_back, size: 20)
            ),
            Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: _searchTextController,
                  decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '搜尋智能櫃',
                ),
                onSubmitted: (value) => _searchLocation(value)
              )
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.search),
            )
          ],
        ),
      ),
    );
  }

}