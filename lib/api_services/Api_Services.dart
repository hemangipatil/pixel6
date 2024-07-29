import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://lab.pixel6.co/api';

  Future<Map<String, dynamic>> verifyPAN(String pan) async {
    final response = await http.post(Uri.parse('$baseUrl/verify-pan.php'), body: {'panNumber': pan});
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getPostcodeDetails(String postcode) async {
    final response = await http.post(Uri.parse('$baseUrl/get-postcode-details.php'), body: {'postcode': postcode});
    return json.decode(response.body);
  }

  Future<List<String>> searchPostcodes(String query) async {
    final response = await http.post(Uri.parse('$baseUrl/search-postcodes.php'), body: {'query': query});
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load postcodes');
    }
  }
}
