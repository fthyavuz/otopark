class DurationFormatter {
  DurationFormatter._();

  static String format(Duration d) {
    final totalMinutes = d.inMinutes;
    if (totalMinutes < 1) return '1 dakikadan az';
    if (totalMinutes < 60) return '$totalMinutes dakika';
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (m == 0) return '$h saat';
    return '$h saat $m dakika';
  }
}
