import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class NumberTrivia extends Equatable {
  final String text;
  final int number;

  const NumberTrivia({
    required this.text,
    required this.number,
  });

  @override
  List<Object> get props => [text, number];
}
