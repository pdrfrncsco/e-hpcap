import 'package:flutter/material.dart';

class DevotionalScreen extends StatelessWidget {
  const DevotionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devocional'),
      ),
      body: const Center(
        child: Text('Conteúdo Devocional Diário'),
      ),
    );
  }
}
