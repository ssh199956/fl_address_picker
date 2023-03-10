class AddressProvince {
  final int? id;
  final String? provinceId;
  final String? province;
  final String? lng;
  final String? lat;
  final List<AddressCity>? cities;

  AddressProvince({
    this.id,
    this.provinceId,
    this.province,
    this.lng,
    this.lat,
    this.cities,
  });

  AddressProvince.fromJson(Map<String, dynamic> json,{Map<String, AddressCity>? cityMap, Map<String, AddressDistrict>? districtMap})
      : id = json['id'] as int?,
        provinceId = json['provinceid'] as String?,
        province = json['province'] as String?,
        lng = json['lng'] as String?,
        lat = json['lat'] as String?,
        cities = (json['cities'] as List?)?.map((dynamic e) => AddressCity.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'provinceid' : provinceId,
    'province' : province,
    'lng' : lng,
    'lat' : lat,
    'cities' : cities?.map((e) => e.toJson()).toList()
  };
}

class AddressCity {
  final int? id;
  final String? city;
  final String? cityid;
  final String? provinceid;
  final String? lng;
  final String? lat;
  final List<AddressDistrict>? district;

  AddressCity({
    this.id,
    this.city,
    this.cityid,
    this.provinceid,
    this.lng,
    this.lat,
    this.district,
  });

  AddressCity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        city = json['city'] as String?,
        cityid = json['cityid'] as String?,
        provinceid = json['provinceid'] as String?,
        lng = json['lng'] as String?,
        lat = json['lat'] as String?,
        district = (json['district'] as List?)?.map((dynamic e) => AddressDistrict.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'city' : city,
    'cityid' : cityid,
    'provinceid' : provinceid,
    'lng' : lng,
    'lat' : lat,
    'district' : district?.map((e) => e.toJson()).toList()
  };
}

class AddressDistrict {
  final int? id;
  final String? area;
  final String? areaid;
  final String? cityid;
  final String? lng;
  final String? lat;

  AddressDistrict({
    this.id,
    this.area,
    this.areaid,
    this.cityid,
    this.lng,
    this.lat,
  });

  AddressDistrict.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        area = json['area'] as String?,
        areaid = json['areaid'] as String?,
        cityid = json['cityid'] as String?,
        lng = json['lng'] as String?,
        lat = json['lat'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'area' : area,
    'areaid' : areaid,
    'cityid' : cityid,
    'lng' : lng,
    'lat' : lat
  };
}