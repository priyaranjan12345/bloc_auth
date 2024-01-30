import 'package:bloc_auth/features/number_trival/domain/entities/number_tivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required super.text,
    required super.number,
  });

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "number": number,
    };
  }

  // -- old --
  // const NumberTriviaModel({
  //   required String text,
  //   required int number,
  // }) : super(text: text, number: number);
}
