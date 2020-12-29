library analytic;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

part 'src/tt_analytic_srv.dart';
part 'src/tt_db_srv.dart';
part 'src/tt_network_srv.dart';
part 'src/tt_network_demo.dart';
part 'src/model/tt_config_info.dart';
part 'src/model/tt_msg_info.dart';
part 'src/model/tt_platform_info.dart';
part 'src/config/tt_parameter_config.dart';
part 'src/config/tt_enum_config.dart';
part 'src/config/tt_ssc_enum_config.dart';
part 'src/utils/tt_utils.dart';
part 'src/tt_platform_srv.dart';

class SSCAnalytic {
  static const String sdkVersion = '1.0.0';
  static const String sdkName = 'SSCAnalytic';
  String _sessionId;
  DateTime _sessionCreated = DateTime.now();

  SSCAnalytic() {
    initAnalyticSrv(cfg: TTConfigInfo.defaultCfg());
    renewSession();
  }

  void renewSession() {
    _sessionCreated = DateTime.now();
    _sessionId = _TTUtils.genSessionId();
  }

  void logEvent({
    ActivityKind activityKind,
    Locale locale,
    LoginMode loginMode,
    String endpointName,
    String dealerId,
    String userId,
    String customerId,
    String productId,
    String modelEnum,
    String modelYearEnum,
    String eventName,
    String eventCategoryName,
    String eventIdentifier,
    String eventTitle,
    String eventValue,
  }) {
    final Map<String, dynamic> params = {};
    params[_ACTIVITY_KIND] = activityKind.toStr();
    params[_LANGUAGE_APP] = '${locale.languageCode}-${locale.countryCode}';
    params[_COUNTRY_CODE] = locale.countryCode.toUpperCase();
    params[_LOGIN_MODE] = loginMode.toStr();
    params[_ENDPOINT_NAME] = endpointName;
    params[_DEALER_ID] = dealerId;
    params[_USER_ID] = userId;
    params[_CUSTOMER_ID] = customerId;
    params[_PRODUCT_ID] = productId;
    params[_MODEL_ENUM] = modelEnum;
    params[_MODEL_YEAR_ENUM] = modelYearEnum;
    params[_EVENT_NAME] = eventName;
    params[_EVENT_CATEGORY_NAME] = eventCategoryName;
    params[_EVENT_IDENTIFIER] = eventIdentifier;
    params[_EVENT_TITLE] = eventTitle;
    params[_EVENT_VALUE] = eventValue;

    _log(parameters: params);
  }

  void _log({@required Map<String, dynamic> parameters}) {
    assert(parameters != null);
    final params = Map.from(parameters);
    params[_SDK_ENVIRONMENT] = kDebugMode ? SdkEnvironment.SANDBOX.toStr() : SdkEnvironment.PRODUCTION.toStr();
    params[_APP_NAME] = platformSrv.info.appName;
    params[_APP_VERSION] = platformSrv.info.appVersion;
    params[_CREATED_AT] = _TTUtils.genUnixTime();
    params[_DEVICE_TYPE] = _TTUtils.getDeviceType();
    params[_OS_NAME] = platformSrv.info.osName;
    params[_OS_VERSION] = platformSrv.info.osVersion;
    params[_RANDOM] = _TTUtils.genRandomNumber();
    params[_NOUNCE] = _TTUtils.genNounce();
    params[_RANDOM_USER_ID] = platformSrv.registrationId;
    params[_APP_VERSION_NAME] = '${platformSrv.info.appVersion}(${platformSrv.info.appBuild})';
    params[_PACKAGE_NAME] = platformSrv.info.appPackageName;
    params[_DEVICE_SCREEN_RESOLUTION] = _TTUtils.getScreenResolution();
    params[_SESSION_ID] = _sessionId;
    params[_TIME_SPEND] = DateTime.now().difference(_sessionCreated).inSeconds;
    analyticSrv.push(parameters: params);
  }
}
