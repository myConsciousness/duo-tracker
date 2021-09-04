enum Flavor {
  FREE,
  PAID,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.FREE:
        return 'Duovoc';
      case Flavor.PAID:
        return 'Duovoc';
      default:
        return 'title';
    }
  }

}
