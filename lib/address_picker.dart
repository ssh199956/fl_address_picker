import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'address_manager.dart';
import 'address_model.dart';

class Address {
  AddressProvince? currentProvince;
  AddressCity? currentCity;
  AddressDistrict? currentDistrict;

  Address({this.currentProvince, this.currentCity, this.currentDistrict});
}

typedef AddressCallback = void Function(Address);

enum AddressPickerMode {
  province,
  provinceAndCity,
  provinceCityAndDistrict,
}

class AddressPicker extends StatefulWidget {
  /// Callback when the selected address changes
  final AddressCallback? onSelectedAddressChanged;
  final Function? onTapEnter;
  final Function? onTapCancel;

  /// Select mode
  /// province Level 1,province
  /// provinceAndCity  Level 2 Provinces and cities
  /// provinceCityAndDistrict Level 3 Provinces, cities and districts
  final AddressPickerMode mode;

  // Provincial and municipal text display style
  final TextStyle style;

  //Top header box decoration
  final BoxDecoration headerDecoration;

  //About provincial color
  final Color firstFlexColor;

  //About municipal color
  final Color secondFlexColor;

  //About color at district level
  final Color thirdFlexColor;

  //Top Territory Customization Area
  final Widget headerText;

  //Whether to display the top area
  //If you set it to false, the top content will not be displayed
  final bool isShowTopHeader;

  final Color bgColor;
  final double widgetHeight;

  const AddressPicker(
      {Key? key,
      this.mode = AddressPickerMode.provinceCityAndDistrict,
      this.onSelectedAddressChanged,
      this.onTapEnter,
      this.onTapCancel,
      this.widgetHeight = 250,
      this.headerDecoration = const BoxDecoration(color: Colors.transparent),
      this.firstFlexColor = const Color(0xFF292B3C),
      this.secondFlexColor = const Color(0xFF292B3C),
      this.thirdFlexColor = const Color(0xFF292B3C),
      this.bgColor = const Color(0xFFFFFFFF),
      this.style = const TextStyle(color: Colors.black, fontSize: 17),
      this.headerText = const Text(
        "属地",
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 17,
        ),
      ),
      this.isShowTopHeader = true})
      : super(key: key);

  _AddressPickerState createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  List<AddressProvince> _provinces = [];

  AddressProvince? _selectedProvince;
  AddressCity? _selectedCity;
  AddressDistrict? _selectedDistrict;

  final FixedExtentScrollController _cityScrollController =
      FixedExtentScrollController(initialItem: 0);
  final FixedExtentScrollController _districtScrollController =
      FixedExtentScrollController(initialItem: 0);

  @override
  void dispose() {
    _cityScrollController.dispose();
    _districtScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getAddressData();
  }

  void _getAddressData() async {
    var addressData = await AddressManager.loadAddressData(context);
    setState(() {
      _provinces = addressData;
      _selectedProvince = _provinces.first;
      _selectedCity = _selectedProvince?.cities?.first;
      _selectedDistrict = _selectedCity?.district?.first;
    });
  }

  void _updateCurrent() {
    if (widget.onSelectedAddressChanged != null) {
      var address = Address(
          currentProvince: _selectedProvince,
          currentCity: _selectedCity,
          currentDistrict: _selectedDistrict);
      widget.onSelectedAddressChanged!(address);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_provinces.isEmpty) {
      return Container();
    }

    return Stack(children: [
      Container(
        height: widget.widgetHeight,
        color: widget.bgColor,
        child: Row(
          children: <Widget>[
            firstFlex(),
            widget.mode == AddressPickerMode.province
                ? Container()
                : secondFlex(),
            widget.mode != AddressPickerMode.provinceCityAndDistrict
                ? Container()
                : thirdFlex()
          ],
        ),
      ),
      header()
    ]);
  }

  Widget firstFlex() {
    return Expanded(
      flex: 1,
      child: CupertinoPicker.builder(
        backgroundColor: widget.firstFlexColor,
        childCount: _provinces.length,
        itemBuilder: (context, index) {
          var item = _provinces[index];
          return Container(
            alignment: Alignment.center,
            child: Text(
              item.province ?? "",
              style: widget.style,
            ),
          );
        },
        itemExtent: 44,
        onSelectedItemChanged: (item) {
          setState(() {
            _selectedProvince = _provinces[item];
            _selectedCity = _selectedProvince?.cities?.first;
            _selectedDistrict = _selectedCity?.district?.first;
            _cityScrollController.animateToItem(0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 250));
            _districtScrollController.animateToItem(0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 250));
          });
          _updateCurrent();
        },
      ),
    );
  }

  Widget thirdFlex() {
    return Expanded(
      flex: 1,
      child: CupertinoPicker.builder(
        scrollController: _districtScrollController,
        backgroundColor: widget.thirdFlexColor,
        childCount: _selectedCity?.district?.length ?? 0,
        itemBuilder: (context, index) {
          var item = _selectedCity?.district?[index];
          return Container(
            alignment: Alignment.center,
            child: Text(
              item?.area ?? "",
              style: widget.style,
            ),
          );
        },
        itemExtent: 44,
        onSelectedItemChanged: (item) {
          var district = _selectedCity?.district?[item];
          _selectedDistrict = district;
          _updateCurrent();
        },
      ),
    );
  }

  Widget secondFlex() {
    return Expanded(
        flex: 1,
        child: CupertinoPicker.builder(
          scrollController: _cityScrollController,
          backgroundColor: widget.secondFlexColor,
          childCount: _selectedProvince?.cities?.length ?? 0,
          itemBuilder: (context, index) {
            var item = _selectedProvince?.cities?[index];
            return Container(
              alignment: Alignment.center,
              child: Text(
                item?.city ?? "",
                style: widget.style,
              ),
            );
          },
          itemExtent: 44,
          onSelectedItemChanged: (item) {
            setState(() {
              _selectedCity = _selectedProvince?.cities?[item];
              _selectedDistrict = _selectedCity?.district?.first;
              _districtScrollController.animateToItem(0,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 250));
            });
            _updateCurrent();
          },
        ));
  }

  Widget header() {
    return Positioned(
      top: 0,
      child: Container(
        height: 30,
        margin: const EdgeInsets.only(left: 14, right: 14),
        decoration: widget.headerDecoration,
        padding: const EdgeInsets.only(top: 13),
        width: 375,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.onTapCancel != null) widget.onTapCancel!();
                Navigator.of(context).pop();
              },
              child: Text(
                "取消",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 15,
                ),
              ),
            ),
            const Spacer(),
            widget.isShowTopHeader ? widget.headerText : Container(),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (widget.onTapEnter != null) widget.onTapEnter!();
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "确认",
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
