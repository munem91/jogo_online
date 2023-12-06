import 'package:dio/dio.dart';

abstract class AbstractDioRepository {
  Future<String?> fetchData();
}

class DioRepository implements AbstractDioRepository {
  DioRepository({
    required this.dio,
  });

  final Dio dio;

  @override
  Future<String?> fetchData() async {
    try {
      // Шаг 1: Составляем URL
      String baseUrl = 'https://api.backendless.com';
      String applicationId = 'A9E9C8B5-1C22-23CD-FFB7-06350D1C3700';
      String apiKey = 'C0F0EBCC-CCF8-43AD-B9D5-B948C9666332';
      String className = 'jogo_bet';
      String objectId = '00D69F45-887A-410F-ACD3-DBDBB79F2F60';

      String url = '$baseUrl/$applicationId/$apiKey/data/$className/$objectId';

      // Шаг 2: Отправляем запрос
      final response = await dio.get(url);

      // Шаг 3: Извлекаем необходимую информацию
      Map<String, dynamic> responseData = response.data;
      String jogoBaseUrl = responseData['jogo_base'];

      // Возвращаем полученную ссылку
      return jogoBaseUrl;
    } on DioError catch (e) {
      // Обработка ошибок Dio
      print('Dio error: $e');
      return null;
    } catch (error) {
      // Обработка других ошибок
      print('Error: $error');
      return null;
    }
  }
}
