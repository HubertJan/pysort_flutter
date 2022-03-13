import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pysort_flutter/providers/result_state.dart';

class RuntimeVisualisation extends StatelessWidget {
  const RuntimeVisualisation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultsState>(builder: (context, state, _) {
      final maxRuntime = state.longestRuntime.inMicroseconds != 0
          ? (state.longestRuntime.inMicroseconds * 1.3).toInt()
          : 1;

      return Container(
        color: Theme.of(context)
            .colorScheme
            .surface, //Theme.of(context).colorScheme.background,
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.sortResults.length,
            itemBuilder: (context, i) {
              final result = state.sortResults.entries.toList()[i];
              return RuntimeBar(
                name: result.key,
                ms: result.value.runtime.inMicroseconds,
                height: result.value.runtime.inMicroseconds / maxRuntime,
              );
            },
          ),
        ),
      );
    });
  }
}

class RuntimeBar extends StatelessWidget {
  final double height;
  final String name;
  final int ms;

  const RuntimeBar(
      {Key? key, required this.height, required this.name, required this.ms})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: height,
              child: Container(
                height: 50,
                color: Colors.yellow,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    "$ms ms",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Text(name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}