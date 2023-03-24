

class City {
  String? city;
  String? country;
  List<PopulationCounts>? populationCounts;

  City({this.city, this.country, this.populationCounts});

  City.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    if (json['populationCounts'] != null) {
      populationCounts = <PopulationCounts>[];
      json['populationCounts'].forEach((v) {
        populationCounts!.add(PopulationCounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['country'] = country;
    if (populationCounts != null) {
      data['populationCounts'] =
          populationCounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PopulationCounts {
  String? year;
  String? value;
  String? sex;
  String? reliabilty;

  PopulationCounts({this.year, this.value, this.sex, this.reliabilty});

  PopulationCounts.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    value = json['value'];
    sex = json['sex'];
    reliabilty = json['reliabilty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['value'] = value;
    data['sex'] = sex;
    data['reliabilty'] = reliabilty;
    return data;
  }
}
