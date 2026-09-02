import 'package:biz_scan_app/core/network/dio_client.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:biz_scan_app/models/regions.dart';
import 'package:biz_scan_app/models/scan_card.dart';
import 'package:biz_scan_app/models/scan_card_reponse.dart';
import 'package:biz_scan_app/models/scanned_card_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ScanProvider extends ChangeNotifier {
  Country? countries;
  Regions? selectedRegion;
  ScannedCardDetails? scannedCardDetails;

  bool isScanning = false;

  void setSelectedRegion(Regions region) {
    selectedRegion = region;
    notifyListeners();
  }

  final DioClient _dioClient = DioClient();


  void resetScan(){
   selectedRegion = null;
    countries = null;
  }

  Future<void> getCountries() async {

    try {
      final response = await _dioClient.get('api/v1/regions');
      countries = Country.fromJson(response.data);

      debugPrint('the countries are $countries');

      notifyListeners();
    } catch (e) {
      debugPrint('the error is $e');
    }
  }

Future<dynamic> scanCardImage(ScanCard card) async {
  try {
    final formData = FormData.fromMap({
      'front': await MultipartFile.fromFile(card.frontImage!),

      if (card.backImage != null)
        'back': await MultipartFile.fromFile(card.backImage!),

      'business_region': card.region,
    });

    final response = await _dioClient.post(
      'api/v1/scans/capture',
      formData,
    );

    return response;
  } catch (e) {
    debugPrint('the error is $e');
    showToast(message: e.toString());
    rethrow;
  }
}

int numberOfTries = 30;

Future<void> getScannedCardDetails(String scanId) async {
  try {
    for (int attempt = 0; attempt < numberOfTries; attempt++) {
      final response = await _dioClient.get(
        'api/v1/scans/$scanId',
      );

      final status = response.data['status'];

      debugPrint('Scan status: $status');

      if (status == 'completed') {
        scannedCardDetails =
            ScannedCardDetails.fromJson(response.data);

        debugPrint(
          'the scanned card details is $scannedCardDetails',
        );

        notifyListeners();
        return;
      }

      if (status == 'failed') {
        throw Exception("Scanning failed");
      }

      if (status == 'queued' || status == 'processing') {
        await Future.delayed(
          const Duration(seconds: 2),
        );

        continue;
      }
    }

    throw Exception("Scanning timed out");
  } catch (e) {
    debugPrint('the error is $e');
    showToast(message: e.toString());
    rethrow;
  }
}

Future<bool> processCard(ScanCard scanCard) async {
  isScanning = true;
  notifyListeners();

  try {
    final response = await scanCardImage(scanCard);

    ScanCardResponse cardResponse =
        ScanCardResponse.fromJson(response);

    await getScannedCardDetails(
      cardResponse.id!,
    );

    return true;
  } catch (e) {
    debugPrint('the error is $e');
    return false;
  } finally {
    isScanning = false;
    notifyListeners();
  }
}
}
