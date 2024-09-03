// import 'package:dio/dio.dart';

class ApiService {
  // final Dio _dio = Dio();

  Future<void> fetchData() async {
    try {
    //   final response = await _dio.get('your_api_endpoint');
      // Process the response data
    //   print(response.data);
    print('Data fetched successfully');
    } catch (e) {
      // Handle errors
      print('Error fetching data: $e');
    }
  }
}