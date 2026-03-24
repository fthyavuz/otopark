import 'package:flutter/material.dart';

class ExitScreen extends StatelessWidget {
  const ExitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Araç Çıkışı')),
      body: const Center(
        child: Text('Araç Çıkış Ekranı\n(Phase 3\'te geliştirilecek)',
            textAlign: TextAlign.center),
      ),
    );
  }
}
