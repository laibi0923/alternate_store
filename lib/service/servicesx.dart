import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

class ServicesX{



  //  upload image
  Future<String> uploadImage(String path, File file) async {

    Reference storageRef = FirebaseStorage.instance.ref().child(path);
    
    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();

    return url;
   
  }




  //    
  String randomStringGender(int chart, bool isString){
    var _chars = '';
    if(isString){
      _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    } else {
      _chars = '1234567890';
    }
    
    Random _rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(
        _rnd.nextInt(_chars.length))
      )
    );

    return getRandomString(chart);
  }


}