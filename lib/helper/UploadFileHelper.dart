import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import '../manager/ApiManager.dart';

class UploadFileHelper {
  static Future<List<dynamic>> uploadPicture(String url, String fieldId, List<dynamic> pictures) async {

    FormData formData = FormData();
    for(dynamic picture in pictures) {
      if (picture is File) {
        formData.files.addAll([
          MapEntry(
            fieldId,
            MultipartFile.fromFileSync(picture.path, filename: basename(picture.path)),
          )
        ]);
      } else if (picture is String) {
        var tempFormData = FormData.fromMap({fieldId: picture});
        formData.fields.addAll(tempFormData.fields);
      }
    }

    Response response = await ApiManager(
        apiMethod: ApiMethod.POST,
        url: url,
        parameters: ApiParameters.uploadFile,
        postData: formData
    ).call();

    Map<String, dynamic> responseMap = response.data;
    print("RESPONSE: " + responseMap.toString());

    List<dynamic> uploadedImages = [];
    responseMap.forEach((fid, value) {
      if(value is String) {
        uploadedImages.add(value);
      } else if(value is List) {
        uploadedImages.addAll(value);
      }
    });
    return uploadedImages;
  }
}