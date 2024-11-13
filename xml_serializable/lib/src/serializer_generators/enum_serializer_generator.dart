import 'package:recase/recase.dart';

import 'serializer_generator.dart';

class EnumSerializerGenerator extends SerializerGenerator {
  /// The name of the type.
  final String _type;

  /// If `false` (the default) then the type does not represent a nullable type.
  final bool _isNullable;

  const EnumSerializerGenerator(
    this._type, {
    bool isNullable = false,
  }) : _isNullable = isNullable;

  String get _enumMap {
    if (_type.contains(".")) {
      final index = _type.indexOf(".");
      return "${_type.substring(0, index)}.\$${_type.substring(index + 1)}";
    }
    return "\$$_type";
  }

  @override
  String generateSerializer(String expression) {
    final buffer = StringBuffer();

    if (_isNullable) {
      buffer.write('$expression != null ? ');
    }

    buffer.write('${_enumMap}EnumMap[$expression]!');

    if (_isNullable) {
      buffer.write(' : null');
    }

    return buffer.toString();
  }

  @override
  String generateDeserializer(String expression) {
    final buffer = StringBuffer();

    if (_isNullable) {
      buffer.write('$expression != null ? ');
    }

    buffer.write(
      '${_enumMap}EnumMap.entries.singleWhere((enumEntry) => enumEntry.value == $expression, orElse: () => throw ArgumentError(\'`\$$expression` is not one of the supported values: \${${_enumMap}EnumMap.values.join(\', \')}\')).key',
    );

    if (_isNullable) {
      buffer.write(' : null');
    }

    return buffer.toString();
  }
}

class NullableEnumSerializerGenerator extends EnumSerializerGenerator {
  const NullableEnumSerializerGenerator(String name)
      : super(name, isNullable: true);
}
