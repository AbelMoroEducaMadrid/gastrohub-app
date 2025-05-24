import 'dart:convert';

class ApiErrorHandler {
  static Map<String, String> handleErrorResponse(dynamic response) {
    try {
      final errorData = jsonDecode(response.body);
      final errorTitle = errorData['error'] ?? 'Error';
      final errorMessage =
          errorData['message'] ?? 'Ocurrió un error inesperado';
      return {
        'title': errorTitle,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'title': 'Error',
        'message': 'Ocurrió un error inesperado',
      };
    }
  }
}
