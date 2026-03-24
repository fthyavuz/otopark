import 'package:flutter/material.dart';

class SubscriberScreen extends StatelessWidget {
  const SubscriberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abonmanlar')),
      body: const Center(
        child: Text('Abonman Yönetim Ekranı\n(Phase 4\'te geliştirilecek)',
            textAlign: TextAlign.center),
      ),
    );
  }
}
