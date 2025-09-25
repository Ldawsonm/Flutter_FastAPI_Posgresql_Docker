import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
class ApiClient {
// Point this to your FastAPI service (Docker: use your host or reverse proxy)
    final String baseUrl;
    ApiClient(this.baseUrl);
    Future<SearchResponse> searchFoods(String query, {int page = 1, int pageSize= 20}) async {
        final uri = Uri.parse('$baseUrl/search').replace(queryParameters: {
            'query': query,
            'page': '$page',
            'page_size': '$pageSize',
        });
        final res = await http.get(uri);
        if (res.statusCode != 200) {
            throw Exception('Search failed: ${res.statusCode} ${res.body}');
        }
            return SearchResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    Future<FoodItem> getFood(int fdcId) async {
        final uri = Uri.parse('$baseUrl/foods/$fdcId');
        final res = await http.get(uri);
        if (res.statusCode != 200) {
            throw Exception('Details failed: ${res.statusCode} ${res.body}');
        }
        return FoodItem.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
}
