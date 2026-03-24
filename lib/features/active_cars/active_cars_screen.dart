import 'package:flutter/material.dart';

class ActiveCarsScreen extends StatelessWidget {
  const ActiveCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İçerideki Araçlar')),
      body: const Center(
        child: Text('Aktif Araçlar Listesi\n(Phase 2\'de geliştirilecek)',
            textAlign: TextAlign.center),
      ),
    );
  }
}
