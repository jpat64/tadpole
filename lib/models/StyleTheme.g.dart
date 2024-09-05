// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StyleTheme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StyleThemeAdapter extends TypeAdapter<StyleTheme> {
  @override
  final int typeId = 2;

  @override
  StyleTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StyleTheme(
      unlocked: fields[0] as bool,
      paletteName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StyleTheme obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.unlocked)
      ..writeByte(1)
      ..write(obj.paletteName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StyleThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
