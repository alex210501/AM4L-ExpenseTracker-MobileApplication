import 'package:am4l_expensetracker_mobileapplication/models/api_request.dart';
import 'package:am4l_expensetracker_mobileapplication/models/category.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/api_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expense_api.dart';

const categoryPath = 'space/:spaceId/category';


/// Class that manage the request for Category
class CategoryApi {
  final String uri;
  final Map<String, String> appJsonHeader;

  /// Constructor
  CategoryApi({required this.uri, required this.appJsonHeader});

  /// Get categories from a space
  Future<List<Category>> getCategories(String spaceId) async {
    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/${categoryPath.replaceAll(':spaceId', spaceId)}',
      method: HttpMethod.get,
      headers: appJsonHeader,
    );

    // Send HTTP request
    List<dynamic> response = await sendHttpRequest(apiRequest);

    // Convert JSON into Categories
    return response
        .map((value) => Category.fromJson(value as Map<String, dynamic>))
        .toList();
  }

  /// Create a category in the API
  Future<Category> createCategory(String spaceId, String categoryTitle) async {
    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/${categoryPath.replaceAll(':spaceId', spaceId)}',
      method: HttpMethod.post,
      headers: appJsonHeader,
      body: { 'category_title': categoryTitle },
    );

    // Send HTTP request
    Map<String, dynamic> response = await sendHttpRequest(apiRequest);

    // Convert JSON into Category
    return Category.fromJson(response);
  }

  /// Delete a category by its ID
  Future<void> removeCategory(String spaceId, String categoryId) async {
    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/${categoryPath.replaceAll(':spaceId', spaceId)}/$categoryId',
      method: HttpMethod.delete,
      headers: appJsonHeader,
    );

    // Send HTTP request
    await sendHttpRequest(apiRequest);
  }
}