import 'flavor_type.dart';

class FlavorConfig {
  FlavorConfig({
    required this.appName,
    required this.type,
  });

  final String appName;
  final FlavorType type;
}
