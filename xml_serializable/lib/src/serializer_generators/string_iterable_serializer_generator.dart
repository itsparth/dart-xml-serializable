import 'serializer_generator.dart';

class StringIterableSerializerGenerator extends SerializerGenerator {
  /// The argument of the closure.
  static const String _closureArgument = 'e';

  /// If `false` (the default) then the type does not represent a nullable type.
  final bool _isNullable;

  /// The generator for generating a serializer for the iterable type argument.
  final SerializerGenerator _generator;

  const StringIterableSerializerGenerator(
    this._generator, {
    bool isNullable = false,
  }) : _isNullable = isNullable;

  @override
  String generateSerializer(String expression) {
    final closureArgument = StringIterableSerializerGenerator._closureArgument;
    final closureResult = _generator.generateSerializer(closureArgument);

    final buffer = StringBuffer(expression);

    if (_isNullable) {
      buffer.write('?');
    }

    buffer.write(".map(($closureArgument) => $closureResult).join(" ")");

    return buffer.toString();
  }

  @override
  String generateDeserializer(String expression) {
    final closureArgument = StringIterableSerializerGenerator._closureArgument;
    final closureResult = _generator.generateDeserializer(closureArgument);

    final buffer = StringBuffer(expression);

    if (_isNullable) {
      buffer.write('?');
    }

    buffer.write(".split(' ').map(($closureArgument) => $closureResult)");

    return buffer.toString();
  }
}

class NullableStringIterableSerializerGenerator
    extends StringIterableSerializerGenerator {
  const NullableStringIterableSerializerGenerator(SerializerGenerator generator)
      : super(generator, isNullable: true);
}

class StringListSerializerGenerator extends StringIterableSerializerGenerator {
  const StringListSerializerGenerator(
    SerializerGenerator generator, {
    bool isNullable = false,
  }) : super(generator, isNullable: isNullable);

  @override
  String generateDeserializer(String expression) {
    final closureArgument = StringIterableSerializerGenerator._closureArgument;
    final closureResult = _generator.generateDeserializer(closureArgument);

    final buffer = StringBuffer(expression);

    if (_isNullable) {
      buffer.write('?');
    }

    buffer.write(".split(' ').map(($closureArgument) => $closureResult)");

    buffer.write('.toList()');

    return buffer.toString();
  }
}

class NullableStringListSerializerGenerator
    extends StringListSerializerGenerator {
  const NullableStringListSerializerGenerator(SerializerGenerator generator)
      : super(generator, isNullable: true);
}

class StringSetSerializerGenerator extends StringIterableSerializerGenerator {
  const StringSetSerializerGenerator(
    SerializerGenerator generator, {
    bool isNullable = false,
  }) : super(generator, isNullable: isNullable);

  @override
  String generateDeserializer(String expression) {
    final closureArgument = StringIterableSerializerGenerator._closureArgument;
    final closureResult = _generator.generateDeserializer(closureArgument);

    final buffer = StringBuffer(expression);

    if (_isNullable) {
      buffer.write('?');
    }

    buffer.write(".split(' ').map(($closureArgument) => $closureResult)");

    buffer.write('.toSet()');

    return buffer.toString();
  }
}

class NullableStringSetSerializerGenerator
    extends StringSetSerializerGenerator {
  const NullableStringSetSerializerGenerator(SerializerGenerator generator)
      : super(generator, isNullable: true);
}
