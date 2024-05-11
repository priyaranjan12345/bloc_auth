import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trival/presentation/bloc/bloc.dart';
import 'features/number_trival/domain/usecases/usecases.dart';
import 'features/number_trival/domain/repositories/repositories.dart';
import 'features/number_trival/data/repositories/repositories.dart';
import 'features/number_trival/data/datasources/datasources.dart';

final injector = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  //* Bloc register
  injector.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: injector(),
      getRandomNumberTrivia: injector(),
      inputConverter: injector(),
    ),
  );

  //* Usecase register
  injector.registerLazySingleton(
    () => GetConcreteNumberTrivia(repository: injector()),
  );
  injector.registerLazySingleton(
    () => GetRandomNumberTrivia(repository: injector()),
  );

  //* register repository
  injector.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      numberTriviaRemoteDatasource: injector(),
      numberTriviaLocalDatasource: injector(),
      networkInfo: injector(),
    ),
  );

  //* register datasources
  injector.registerLazySingleton<NumberTriviaLocalDatasource>(
    () => NumberTriviaLocalDatasourceImpl(sharedPreferences: injector()),
  );
  injector.registerLazySingleton<NumberTriviaRemoteDatasource>(
    () => NumberTriviaRemoteDatasourceImpl(httpClient: injector()),
  );

  //* register core
  injector.registerLazySingleton(() => InputConverter());
  injector.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: injector()),
  );

  //* register external
  final sharedPreference = await SharedPreferences.getInstance();
  injector.registerLazySingleton(
    () => sharedPreference,
  );
  injector.registerLazySingleton(
    () => http.Client(),
  );
  injector.registerLazySingleton(
    () => DataConnectionChecker(),
  );
}
