// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:connectivity_plus/connectivity_plus.dart';

class Network {
  static Future<bool> isConnected() async {
    final connectivity = await (Connectivity().checkConnectivity());
    return await _isMobileConnected(connectivity: connectivity) ||
        await _isWifiConnected(connectivity: connectivity);
  }

  static Future<bool> _isMobileConnected({
    ConnectivityResult? connectivity,
  }) async {
    connectivity ??= await (Connectivity().checkConnectivity());

    return connectivity == ConnectivityResult.mobile;
  }

  static Future<bool> _isWifiConnected({
    ConnectivityResult? connectivity,
  }) async {
    connectivity ??= await (Connectivity().checkConnectivity());

    return connectivity == ConnectivityResult.wifi;
  }
}
