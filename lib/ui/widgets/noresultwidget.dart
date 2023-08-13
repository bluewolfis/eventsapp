import 'package:flutter/material.dart';

class NoResult extends StatelessWidget {
  const NoResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/noresults.png"),
          const SizedBox(
            height: 16,
          ),
          Text("No Results", style: Theme.of(context).textTheme.bodySmall)
        ],
      ),
    );
  }
}
