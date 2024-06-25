import '../../utils/enums.dart';
import '../configurations/app_config.dart';
import '../network/network_info.dart';
import 'cloud_services_impl.dart';

class CloudServices {
  final CloudServicesImpl _pushNotificationsManager;
  final NetworkInfo networkInfo;

  CloudServices(this._pushNotificationsManager, this.networkInfo);

  

  
  topicSubscribe(String topic) {
    if(AppConfig.deviceOS == DeviceOS.ANDROID) {
      
    } else {
      
    }
  }

  topicUnsubscribe(String topic) {
    if(AppConfig.deviceOS == DeviceOS.ANDROID) {
      
    } else {
      
    }
  }
}
