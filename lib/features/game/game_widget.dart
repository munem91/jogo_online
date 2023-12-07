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
      print(url);
      final result = await dio.get(
        url,
        options: Options(followRedirects: false),
      );

      // Добавим информацию о ответе в лог

      // Обработка успешного ответа
      Map<String, dynamic>? responseData = result.data;
      print(responseData);
      String? url2;
      if (responseData != null) {
        url2 = responseData['jogo_base'] as String?;
        print(url2);
        if (url2 != null) {
          // Отправить запрос по URL из url2
          final url2Result = await dio.get(
            url2,
            
            options: Options(followRedirects: false),
          );
                    print('Status Code from url2Result: ${url2Result.statusCode}');

        }
      }
      return url2;
    } on DioException catch (e) {
      
      if (e.response!.statusCode == 302) {
        // return e.response!.headers['location']![0];
        print('302!!!!!!!!!!!!');
      }
      return null;
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }
}
