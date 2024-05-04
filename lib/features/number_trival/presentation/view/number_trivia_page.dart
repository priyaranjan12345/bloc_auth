import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import 'number_trivia_view.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<NumberTriviaBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Number Trivia"),
        ),
        body: const NumberTriviaView(),
      ),
    );
  }
}
