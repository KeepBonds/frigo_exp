import 'dart:io';

class FileHelper {
  static bool hasFile(List<dynamic> pictures) {
    for(dynamic picture in pictures) {
      if(picture is File) {
        return true;
      }
    }
    return false;
  }
}