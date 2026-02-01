import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/user.dart';

abstract class UserRemoteDataSource {
  Future<User> getCurrentUser();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<User> getCurrentUser() async {
    final response = await dio.get('${ApiEndpoints.baseUrl}/auth/me');

    print('User Remote Data Source - Response: ${response.data}');

    // Handle response wrapper from backend
    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      // Extract the actual data (backend wraps in {statusCode, message, data})
      Map<String, dynamic> userData;

      if (responseData.containsKey('data')) {
        final dataField = responseData['data'];

        // The data field contains {user: {...}}
        if (dataField is Map<String, dynamic> &&
            dataField.containsKey('user')) {
          userData = dataField['user'] as Map<String, dynamic>;
        } else if (dataField is Map<String, dynamic>) {
          userData = dataField;
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        userData = responseData;
      }

      print('User Remote Data Source - Extracted User Data: $userData');

      return User.fromJson(userData);
    }

    throw Exception('Invalid response format: ${response.data.runtimeType}');
  }
}
