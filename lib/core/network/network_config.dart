import 'package:resume_radar/flavors/flavor_config.dart';

const CONNECT_TIMEOUT = 60 * 1000;
const RECEIVE_TIMEOUT = 60 * 1000;

class IPAddress {
  /// DEV
  static const String DEV = 'api-dev-refresh.nezt.app/';

  /// STAGING
  static const String STG = 'api-qa-refresh.nezt.app/';

  /// PRODUCTION
  static const String PROD = 'api-sandbox-refresh.nezt.app/';
}

class ServerProtocol {
  static const String DEV = 'https://';
  static const String STG = 'https://';
  static const String PROD = 'https://';
}

class NetworkConfig {
  static String getNetworkUrl() {
    String url = _getProtocol() + _getBaseURL();
    return url;
  }

  static String _getProtocol() {
    if (FlavorConfig.isDevelopment()) {
      return ServerProtocol.DEV;
    } else if (FlavorConfig.isStaging()) {
      return ServerProtocol.STG;
    } else {
      return ServerProtocol.PROD;
    }
  }

  static String _getBaseURL() {
    if (FlavorConfig.isDevelopment()) {
      return IPAddress.DEV;
    } else if (FlavorConfig.isStaging()) {
      return IPAddress.STG;
    } else {
      return IPAddress.PROD;
    }
  }
}
