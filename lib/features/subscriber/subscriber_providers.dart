import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';

final allSubscribersProvider = StreamProvider<List<Subscriber>>((ref) {
  return ref.watch(databaseProvider).watchAllSubscribers();
});

final allSubscriberPlatesProvider = StreamProvider<List<SubscriberPlate>>((ref) {
  return ref.watch(databaseProvider).watchAllSubscriberPlates();
});
