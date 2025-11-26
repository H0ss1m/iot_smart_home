import 'package:flutter/material.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Devices Page')),
      body: Center(
        child: Text('Soon', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}