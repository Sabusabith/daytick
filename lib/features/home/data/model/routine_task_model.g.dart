// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineTaskModelAdapter extends TypeAdapter<RoutineTaskModel> {
  @override
  final int typeId = 0;

  @override
  RoutineTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineTaskModel(
      time: fields[0] as String,
      title: fields[1] as String,
      isDone: fields[2] as bool,
      isActive: fields[3] as bool,
      isUserAdded: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineTaskModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isDone)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.isUserAdded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
