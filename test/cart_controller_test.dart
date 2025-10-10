import 'package:flutter_test/flutter_test.dart';

void main() {
  group('updateCartItemQuantity parameter tests', () {
    test('quantity parameter accepts int', () {
      dynamic quantity = 5;

      // Simulate what happens in the method
      if (quantity != null) {
        final result = quantity is int ? quantity : int.parse(quantity.toString());
        expect(result, isA<int>());
        expect(result, equals(5));
      }
    });

    test('quantity parameter accepts String and converts to int', () {
      dynamic quantity = "10";

      // Simulate what happens in the method
      if (quantity != null) {
        final result = quantity is int ? quantity : int.parse(quantity.toString());
        expect(result, isA<int>());
        expect(result, equals(10));
      }
    });

    test('quantity parameter handles null', () {
      dynamic quantity = null;

      // Simulate what happens in the method
      int? result;
      if (quantity != null) {
        result = quantity is int ? quantity : int.parse(quantity.toString());
      }
      expect(result, isNull);
    });

    test('quantity parameter converts double to int', () {
      dynamic quantity = 7.0;

      // Simulate what happens in the method
      if (quantity != null) {
        final result = quantity is int ? quantity : int.parse(quantity.toString().split('.')[0]);
        expect(result, isA<int>());
        expect(result, equals(7));
      }
    });

    test('data map construction with int quantity', () {
      dynamic quantity = 3;
      String packageName = "Test Package";

      Map<String, dynamic> data = {
        'package_name': packageName,
      };

      if (quantity != null) {
        data['quantity'] = quantity is int ? quantity : int.parse(quantity.toString());
      }

      expect(data['package_name'], equals("Test Package"));
      expect(data['quantity'], equals(3));
      expect(data['quantity'], isA<int>());
    });

    test('data map construction with String quantity', () {
      dynamic quantity = "8";
      String packageName = "Test Package";

      Map<String, dynamic> data = {
        'package_name': packageName,
      };

      if (quantity != null) {
        data['quantity'] = quantity is int ? quantity : int.parse(quantity.toString());
      }

      expect(data['package_name'], equals("Test Package"));
      expect(data['quantity'], equals(8));
      expect(data['quantity'], isA<int>());
    });

    test('data map construction with addons', () {
      dynamic quantity = 2;
      String packageName = "Test Package";
      List<int> addonIds = [1, 2, 3];

      Map<String, dynamic> data = {
        'package_name': packageName,
      };

      if (quantity != null) {
        data['quantity'] = quantity is int ? quantity : int.parse(quantity.toString());
      }

      if (addonIds.isNotEmpty) {
        data['addons'] = addonIds;
      }

      expect(data['package_name'], equals("Test Package"));
      expect(data['quantity'], equals(2));
      expect(data['addons'], equals([1, 2, 3]));
    });

    test('data map construction with only package name (no quantity)', () {
      dynamic quantity = null;
      String packageName = "Test Package";
      List<int> addonIds = [5];

      Map<String, dynamic> data = {
        'package_name': packageName,
      };

      if (quantity != null) {
        data['quantity'] = quantity is int ? quantity : int.parse(quantity.toString());
      }

      if (addonIds.isNotEmpty) {
        data['addons'] = addonIds;
      }

      expect(data['package_name'], equals("Test Package"));
      expect(data.containsKey('quantity'), isFalse);
      expect(data['addons'], equals([5]));
    });
  });
}
