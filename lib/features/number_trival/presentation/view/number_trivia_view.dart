import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class NumberTriviaView extends StatefulWidget {
  const NumberTriviaView({super.key});

  @override
  State<NumberTriviaView> createState() => _NumberTriviaViewState();
}

class _NumberTriviaViewState extends State<NumberTriviaView> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) => switch (state) {
              InitialNumberTriviaState() => Container(),
              LoadingNumberTriviaState() => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              LoadedNumberTriviaState() => RichText(
                  text: TextSpan(
                    text: 'Result: ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '${state.trivia.number}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' ${state.trivia.text}!'),
                    ],
                  ),
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
              Expanded(
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
              const SizedBox(width: 20),
              Expanded(
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

// Text(
//                   "Result: ${state.trivia.number} ${state.trivia.text}",
//                   style: Theme.of(context).textTheme.displayMedium,
//                 )
