
import 'network_client.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService _service = ApiService._privateConstructor();

  factory ApiService() {
    return _service;
  }

  static NetworkClient networkClient = NetworkClient();
}