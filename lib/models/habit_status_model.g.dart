// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_status_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitStatusAdapter extends TypeAdapter<HabitStatus> {
  @override
  final int typeId = 2;

  @override
  HabitStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitStatus(
      habitId: fields[0] as String,
      date: fields[1] as String,
      isCompleted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HabitStatus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.habitId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
