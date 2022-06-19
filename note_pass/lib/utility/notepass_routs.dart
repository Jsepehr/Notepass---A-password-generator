class Routs {
  static const String _configRoute = "/config_route";
  static const String _passRoute = "/pass_route";

  getrouts(select) {
    switch (select) {
      case "config":
        return _configRoute;
      case "pass":
        return _passRoute;
    }
  }
}
