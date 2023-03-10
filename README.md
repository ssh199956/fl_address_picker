<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
## fl_address_picker

As shown in the figure below:

<img decoding="async" src="https://i.ibb.co/yFbbPj4/20230309-190707.jpg">

图片地址：<https://i.ibb.co/yFbbPj4/20230309-190707.jpg>

Welcome to my personal website：<https://www.sshlearning.cn>

Welcome to my github and invite you to build more：<https://github.com/ssh199956>

Welcome to my personal blog：<https://blog.sshlearning.cn>

Welcome to follow my document content：<https://data.sshlearning.cn>

Welcome to the static e-commerce website made during my study：<https://shenfeng.sshlearning.cn>

## Getting started

A Flutter plugin that supports address_picker for selecting addresses, suitable for Android, iOS and
other platforms.

## Usage

```dart
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('show'),
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.black45,
                context: context,
                builder: (context) =>
                    BottomSheet(
                        onClosing: () {},
                        builder: (context) =>
                            Container(
                              color: EMOColors.root_bg,
                              height: 250.0,
                              child: AddressPicker(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                                mode: AddressPickerMode.province,
                                onSelectedAddressChanged: (address) {
                                  logic.uploadArea.value =
                                      address.currentProvince.province;
                                  print(
                                      '${address.currentProvince.province}');
                                },
                                onTap: setArea,
                              ),
                            )));
          },
        ),
      ),
    );
  }
}
```

### Property

- **mode**:

```dart
/// 选择模式
/// province 一级: 省
/// provinceAndCity 二级: 省市 
/// provinceCityAndDistrict 三级: 省市区
final AddressPickerMode mode;
```

- **onSelectedAddressChanged**:

```dart
/// 选中的地址发生改变回调
final AddressCallback onSelectedAddressChanged;
```

- **style**:

```dart
/// 省市区文字显示样式
final TextStyle style;
```