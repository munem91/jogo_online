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
      String six = somethingSix;
      String seven = somethingSeven;
      String eight = somethingEight;

      String firstGenerator = '$one$two$three$six$four$five';
      final result = await dio.get(
        firstGenerator,
        options: Options(followRedirects: false),
      );

      Map<String, dynamic>? responseData = result.data;
      String? secondGenerator;
      if (responseData != null) {
        secondGenerator = responseData[seven] as String?;
        if (secondGenerator != null) {
          final responseTwo = await dio.get(
            secondGenerator,
            options: Options(followRedirects: false),
          );
          if (responseTwo.statusCode == 302) {
            return responseTwo.headers[eight]![0];
          } else {
            return null;
          }
        }
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 302) {
        return e.response!.headers[eight]![0];
      }
      return null;
    } catch (error) {
      return null;
    }
    return null;
  }
}
