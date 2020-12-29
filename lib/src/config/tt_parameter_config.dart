part of analytic;

// ----- PRIVATE ------------------

/// Current SDK environment setting
const String _SDK_ENVIRONMENT = 'environment';

/// Name of the app
const String _APP_NAME = 'app_name';

/// App version name
const String _APP_VERSION = 'app_version';

/// App build code
// const String _APP_BUILD = 'app_build';

/// Activity timestamp (in seconds)
const String _CREATED_AT = 'created_at';

/// Device type
const String _DEVICE_TYPE = 'device_type';

/// Device operating system
const String _OS_NAME = 'os_name';

/// Operating system version number
const String _OS_VERSION = 'os_version';

/// Random number (unique per callback)
const String _RANDOM = 'random';

/// Random lowercase alphanumeric string (unique per callback)
const String _NOUNCE = 'nounce';

/// Random user ID (per device per app)
const String _RANDOM_USER_ID = 'random_user_id';

/// Version name of the app
const String _APP_VERSION_NAME = 'ivt_av';

/// Package name of the app
const String _PACKAGE_NAME = 'ivt_aid';

/// Screen resolution
const String _DEVICE_SCREEN_RESOLUTION = 'ivt_sr';

// ----- PUBLIC ------------------

/// Type of user activity
const String _ACTIVITY_KIND = 'activity_kind';

/// Session Id
const String _SESSION_ID = 'ivt_sc';

/// Length of user's current session (in seconds)
const String _TIME_SPEND = 'time_spend';

/// The current user's language of the app.
/// (Not the OS language)
const String _LANGUAGE_APP = 'ivt_ul';

/// Two-character country code of the app
const String _COUNTRY_CODE = 'ivt_cc';

/// Login mode
const String _LOGIN_MODE = 'ivt_lm';

/// Runtime environment of the app
const String _ENDPOINT_NAME = 'ivt_env';

/// Dealer Id of the user's current session
const String _DEALER_ID = 'ivt_tid';

/// User Id of the user's current session
const String _USER_ID = 'ivt_uid';

/// Customer Id of the user's current session
const String _CUSTOMER_ID = 'ivt_cid';

/// Product Id of the user's current session
const String _PRODUCT_ID = 'ivt_pid';

/// Selected Model Enum
const String _MODEL_ENUM = 'ivt_pm';

/// Selected Model Year Enum
const String _MODEL_YEAR_ENUM = 'ivt_pmy';

/// Event name
const String _EVENT_NAME = 'event';

/// Category name of the event
const String _EVENT_CATEGORY_NAME = 'ivt_ct';

/// Identifier that can identify the object on which the event occurred
const String _EVENT_IDENTIFIER = 'ivt_oid';

/// Display name that can identify the object on which the event occurred
const String _EVENT_TITLE = 'ivt_otl';

/// Event value
const String _EVENT_VALUE = 'ivt_val';
