import 'dart:convert';

import 'package:bloc_auth/core/apis/app_uri.dart';
import 'package:bloc_auth/core/error/custom_exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  /// calls the `http://numbersapi.com/{number}?json` endpoint
  ///
  /// throws a [ServerException] for all err codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// calls the `http://numbersapi.com/random?json` endpoint
  ///
  /// throws a [ServerException] for all err codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  final http.Client httpClient;

  NumberTriviaRemoteDatasourceImpl({
    required this.httpClient,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await httpClient.get(AppUri.getUri(path: "$number?json"));

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await httpClient.get(AppUri.getUri(path: "random?json"));

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
