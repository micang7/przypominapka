import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';

/// Riverpod provider dla HttpClient singleton'a
final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient();
});
