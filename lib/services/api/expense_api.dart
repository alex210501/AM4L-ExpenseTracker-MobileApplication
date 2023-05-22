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

  /// Create an expense to the API
  Future<Expense> createExpense(String spaceId, Expense expense) async {
    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/${expensePath.replaceAll(':spaceId', spaceId)}',
      method: HttpMethod.post,
      headers: appJsonHeader,
      body: {
        'expense_cost': expense.cost,
        'expense_date': expense.date,
        'expense_description': expense.description,
      },
    );

    // Send HTTP request
    final response = await sendHttpRequest(apiRequest);

    // Convert JSON to Expense
    return Expense.fromJson(response);
  }

  /// Delete an expense from the API
  Future<void> deleteExpense(String spaceId, String expenseId) async {
    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/${expensePath.replaceAll(':spaceId', spaceId)}/$expenseId',
      method: HttpMethod.delete,
      headers: appJsonHeader,
    );

    // Send HTTP request
    await sendHttpRequest(apiRequest);
  }

  /// Update an expense
  Future<void> patchExpense(String spaceId, Expense expense) async {
    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/${expensePath.replaceAll(':spaceId', spaceId)}/${expense.id}',
      method: HttpMethod.patch,
      headers: appJsonHeader,
      body: {
        'expense_description': expense.description,
        'expense_cost': expense.cost,
      }
    );

    // Send HTTP request
    await sendHttpRequest(apiRequest);
  }
}