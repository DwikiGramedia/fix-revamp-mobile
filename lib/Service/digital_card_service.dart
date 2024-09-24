import 'dart:convert';

import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_constant.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';

class DigitalCardService {
  static final DigitalCardService _instance = DigitalCardService._internal();
  factory DigitalCardService() => _instance;
  DigitalCardService._internal();
  static DigitalCardService get instance => _instance;

  Future<String?> getDigitalCard({
    required int userId,
  }) async {
    try {
      String endpoint = ApiClient.instance.baseUrl +
          ApiConstant.digitalCard(
            ApiClient.instance.baseOrganizationId,
            userId,
          );
      await debugLog('digital endpoint: $endpoint');
      final response = await ApiClient.instance.getDataDio(endpoint, '');
      await debugLog(response as String);
      if (response.data!['status'] != 404) {
        final String? imageUrl = response.data!['digital_card']['image'] ?? '';
        return imageUrl;
      } else {
        return '';
      }
    } catch (err) {
      rethrow;
    }
  }
}
