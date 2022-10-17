class Routs {
  static const String _configRoute = "/config_route";
  static const String _passRoute = "/pass_route";
  static const String _aboutRoute = "/about_route";

  getrouts(select) {
    switch (select) {
      case "config":
        return _configRoute;
      case "pass":
        return _passRoute;
      case "about":
        return _aboutRoute;
    }
  }
}
