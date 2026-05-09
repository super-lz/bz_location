import 'package:bz_location/bz_location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('default location option is high accuracy', () {
    final option = AMapLocationOption();
    expect(option.locationMode, AMapLocationMode.Hight_Accuracy);
    expect(option.needAddress, isTrue);
  });

  test('option map contains iOS and Android fields', () {
    final option = AMapLocationOption();
    final map = option.getOptionsMap();
    expect(map['locationInterval'], 2000);
    expect(map['desiredAccuracy'], DesiredAccuracy.Best.index);
  });
}
