part of analytic;

class _NetworkDemo {
  static Future<http.Response> post(String url, {Map<String, dynamic> headers, dynamic body, Encoding encoding}) async {
    final resBody = {
      "result": null,
      "targetUrl": null,
      "success": true,
      "error": null,
      "unAuthorizedRequest": false,
      "__abp": true,
    };
    return http.Response(jsonEncode(resBody), 500);
  }
}
