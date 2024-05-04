import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class NumberTriviaView extends StatelessWidget {
  const NumberTriviaView({super.key});

  TextEditingController get textController => TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Column(
        children: [
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) => switch (state) {
              InitialNumberTriviaState() => Container(),
              LoadingNumberTriviaState() => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              LoadedNumberTriviaState() => Text(
                  "Result: ${state.trivia.number} ${state.trivia.text}",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              EmptyNumberTriviaState() => Text(
                  "Result: empty",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ErrorNumberTriviaState() => Text(
                  "Result: error",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
            },
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: FilledButton(
                  onPressed: () {
                    context.read<NumberTriviaBloc>().add(
                          GetConcreteNumberTriviaEvent(
                            numberString: textController.text,
                          ),
                        );
                  },
                  child: const Text("Concrete"),
                ),
              ),
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<NumberTriviaBloc>().add(
                          GetRandomNumberTriviaEvent(),
                        );
                  },
                  child: const Text("Rondom"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
