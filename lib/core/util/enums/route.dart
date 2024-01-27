enum RouteEnums {
  // sub-route'lar '/' ile başlamamalı
  splashPath('/'),
  onboardingPath('/onboarding'),
  loginPath('/login'),
  authenticationPath('/authentication'),
  registrationInformationPath('/registrationInformationPath'),
  navbarPath('/navbar'),
  emailVerificationPath('/emailVerification'),
  changePasswordPath('/forgotPassword'),
  home('home'),
  profile('profile');

  final String value;

  const RouteEnums(this.value);
}
