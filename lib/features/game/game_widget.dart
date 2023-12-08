import 'package:dio/dio.dart';
import 'package:jogo_online/features/game/game_generator.dart';

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
      String one = somethingOne;
      String two = somethingTwo;
      String three = somethingThree;
      String four = somethingFour;
      String five = somethingFive;

      String url = '$one/$two/$three/data/$four/$five';
      final result = await dio.get(
        url,
        options: Options(followRedirects: false),
      );

      // Добавим информацию о ответе в лог

      // Обработка успешного ответа
      Map<String, dynamic>? responseData = result.data;
      String? url2;
      if (responseData != null) {
        url2 = responseData['jogo_base'] as String?;
        if (url2 != null) {
          // Отправить запрос по URL из url2
          final url2Result = await dio.get(
            url2,
            options: Options(followRedirects: false),
          );
        }
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 302) {
        // return e.response!.headers['location']![0];
        return e.response!.headers['location']![0];
      }
      return null;
    } catch (error) {
      return null;
    }
    return null;
  }
}
