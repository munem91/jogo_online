import 'package:dio/dio.dart';
import 'package:jogo_bbrbet_online/features/game/game_generator.dart';

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
      String one = somethingOne;
      String two = somethingTwo;
      String three = somethingThree;
      String four = somethingFour;
      String five = somethingFive;

      String startOne = '$one$two/$three/data/$four/$five';
      final result = await dio.get(
        startOne,
        options: Options(followRedirects: false),
      );

      Map<String, dynamic>? responseData = result.data;
      String? startTwo;
      if (responseData != null) {
        startTwo = responseData['jogo_base'] as String?;
        if (startTwo != null) {
          final responseTwo = await dio.get(
            startTwo,
            options: Options(followRedirects: false),
          );
          if (responseTwo.statusCode == 302) {
            return responseTwo.headers['location']![0];
          } else {
            return null;
          }
        }
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 302) {
        return e.response!.headers['location']![0];
      }
      return null;
    } catch (error) {
      return null;
    }
    return null;
  }
}
