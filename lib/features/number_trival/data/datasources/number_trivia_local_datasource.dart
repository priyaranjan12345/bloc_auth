import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/custom_exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Get the cache [NumberTriviaModel] which gotten the last time.
  ///
  /// Throws a [NoLocalDataException] for all err codes.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// cache number trivia
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;
  String cacheKey = "cache-data";

  NumberTriviaLocalDatasourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) async {
    final jsonData = json.encode(numberTriviaModel.toJson());
    final isSaved = await sharedPreferences.setString(cacheKey, jsonData);

    if (!isSaved) {
      throw CacheException();
    }
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final cachedJsonData = sharedPreferences.getString(cacheKey);

    if (cachedJsonData != null) {
      return NumberTriviaModel.fromJson(json.decode(cachedJsonData));
    }

    throw CacheException();
  }
}
