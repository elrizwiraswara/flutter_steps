import 'package:flutter/material.dart';

class SampleWrapper extends StatelessWidget {
  final String title;
  final Widget widget;

  const SampleWrapper({
    super.key,
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          widget,
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
