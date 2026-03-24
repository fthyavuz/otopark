import 'package:flutter/material.dart';

class ExitScreen extends StatelessWidget {
  const ExitScreen({super.key, this.prefilledPlate});

  final String? prefilledPlate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Araç Çıkışı')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefilledPlate != null) ...[
              Text(
                prefilledPlate!,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Çıkış & Ödeme Ekranı\n(Phase 3\'te geliştirilecek)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
