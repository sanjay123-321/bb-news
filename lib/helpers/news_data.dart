import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bbnews/helpers/strings.dart';

Future<String> getNewsImage(String postId) async {
  try {
    final response = await http.get(Uri.parse('${baseUrl}media/23'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body); // Parse the map

      if (data.containsKey('guid')) {
        Map<String, dynamic> guid = data['guid'];
        if (guid.containsKey('rendered')) {
          String imageUrl = guid['rendered'];
          return imageUrl;
        }
      }
    }

    throw Exception('Failed to fetch image URL');
  } catch (e) {
    print('Error fetching image URL: $e');
    throw Exception('Failed to fetch image URL');
  }
}
