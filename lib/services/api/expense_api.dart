import 'package:am4l_expensetracker_mobileapplication/models/api_request.dart';
import 'package:am4l_expensetracker_mobileapplication/models/expense.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/api_tools.dart';

const expensePath = 'space/:spaceId/expense';


/// Class that manage the request for Expense
class ExpenseApi {
  final String uri;
  final Map<String, String> appJsonHeader;

  /// Constructor
  ExpenseApi({required this.uri, required this.appJsonHeader});

  /// Get expenses from a space
  Future<List<Expense>> getExpenses(String spaceId) async {
    ApiRequest apiRequest = ApiRequest(
        uri: '$uri/${expensePath.replaceAll(':spaceId', spaceId)}',
        method: HttpMethod.get,
        headers: appJsonHeader,
    );

    // Send HTTP request
    List<dynamic> response = await sendHttpRequest(apiRequest);

    // Convert JSON into Expenses
    return response
        .map((value) => Expense.fromJson(value as Map<String, dynamic>))
        .toList();
  }
}