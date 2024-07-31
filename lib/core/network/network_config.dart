import 'package:resume_radar/flavors/flavor_config.dart';

const CONNECT_TIMEOUT = 60 * 1000;
const RECEIVE_TIMEOUT = 60 * 1000;

class IPAddress {
  /// DEV
  static const String DEV = '10.0.2.2:5000/';

  /// STAGING
  static const String STG = '10.0.2.2:5000/';

  /// PRODUCTION
  static const String PROD = '10.0.2.2:5000/';
}

class ServerProtocol {
  static const String DEV = 'http://';
  static const String STG = 'http://';
  static const String PROD = 'http://';
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
