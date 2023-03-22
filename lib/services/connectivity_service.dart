import 'dart:async';
import 'dart:io';

class ConnectivityService {
  Future<bool> checkConnectivity (Function function, Function fails) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        function();
        return true;
      }
      else {
        print('not connected');
        fails();
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      fails();
      return false;
    }
  }
}