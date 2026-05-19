/// Shared API configuration for the landing + app services.
const String kApiBaseUrl =
    String.fromEnvironment('YD_API_BASE_URL', defaultValue: 'https://youdefineyou.org/api/v1');

const String kLandingPageUrl =
    String.fromEnvironment('YD_LANDING_URL', defaultValue: 'https://youdefineyou.org');

const String kSupportEmail =
    String.fromEnvironment('YD_SUPPORT_EMAIL', defaultValue: 'hello@youdefineyou.org');
