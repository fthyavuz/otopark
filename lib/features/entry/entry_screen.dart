import 'package:flutter/material.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Araç Girişi')),
      body: const Center(
        child: Text('Araç Giriş Ekranı\n(Phase 2\'de geliştirilecek)',
            textAlign: TextAlign.center),
      ),
    );
  }
}
