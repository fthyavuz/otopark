import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raporlar')),
      body: const Center(
        child: Text('Raporlar Ekranı\n(Phase 5\'te geliştirilecek)',
            textAlign: TextAlign.center),
      ),
    );
  }
}
