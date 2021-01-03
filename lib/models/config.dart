class Config {
  String profile;
  Config(this.profile);

  Map<String, dynamic> toJson() {
    return {
      "profile": this.profile,
    };
  }

  Config.fromJson(Map<String, dynamic> json) {
    this.profile = json["profile"];
  }
}
