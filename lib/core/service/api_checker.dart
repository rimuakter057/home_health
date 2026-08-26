class ApiChecker {

  // ── Check success ─────────────────────────────────────
  static bool isSuccess(Map<String, dynamic> response) {
    return response['success'] == true;
  }

  // ── Get error chat ─────────────────────────────────
  static String getErrorMessage(Map<String, dynamic> response) {
    // 1. Try errorMessages list first
    if (response['errorMessages'] != null &&
        response['errorMessages'] is List &&
        (response['errorMessages'] as List).isNotEmpty) {
      final first = (response['errorMessages'] as List)[0];
      if (first['chat'] != null) return first['chat'];
    }

    // 2. Fallback to chat field
    if (response['chat'] != null &&
        response['chat'].toString().isNotEmpty) {
      return response['chat'];
    }

    // 3. Default
    return 'Something went wrong.';
  }
}