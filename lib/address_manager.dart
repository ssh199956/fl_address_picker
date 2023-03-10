import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'address_model.dart';

abstract class AddressManager {

  static List<AddressProvince> _provinces=[];
  static final Map<String, AddressProvince> _provinceMap = <String, AddressProvince>{};
  static final Map<String, AddressCity> _cityMap = <String, AddressCity>{};
  static final Map<String, AddressDistrict> _districtMap = <String, AddressDistrict>{};

  static Future<List<AddressProvince>> loadAddressData (
      BuildContext context) async {

    if (_provinces.isNotEmpty) {
      return _provinces;
    }
    var address = await rootBundle.loadString('packages/fl_address_picker/assets/address.json');
    var data = json.decode(address);
      var provinces = <AddressProvince>[];
      if (data is List) {
        for (var v in data) {
          var province = AddressProvince.fromJson(v);
          _provinceMap[province.provinceId!] = province;
          provinces.add(province);
        }
        _provinces = provinces;
        return _provinces;
      }
      return <AddressProvince>[];
  }

  static Future<AddressProvince?> getProvince(BuildContext context, String provinceId) async {
    if (_provinceMap.isEmpty) {
      var provinces = await loadAddressData(context);
      if (provinces.isNotEmpty) {
        return _provinceMap[provinceId];
      }
      return null;
    } else {
      return _provinceMap[provinceId];
    }
  }

  static Future<AddressCity?> getCity(BuildContext context, String cityId) async {
    if (_cityMap.isEmpty) {
      var provinces = await loadAddressData(context);
      if (provinces.isNotEmpty) {
        return _cityMap[cityId];
      }
      return null;
    } else {
      return _cityMap[cityId];
    }
  }

  static Future<AddressDistrict?> getDistrict(BuildContext context, String districtId) async {
    if (_districtMap.isEmpty) {
      var provinces = await loadAddressData(context);
      if (provinces.isNotEmpty) {
        return _districtMap[districtId];
      }
      return null;
    } else {
      return _districtMap[districtId];
    }
  }
}
