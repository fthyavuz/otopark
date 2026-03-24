import 'package:flutter/material.dart';

class TariffScreen extends StatelessWidget {
  const TariffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarife Yönetimi')),
      body: const Center(
        child: Text('Tarife Yönetim Ekranı\n(Phase 2\'de geliştirilecek)',
            textAlign: TextAlign.center),
      ),
    );
  }
}
