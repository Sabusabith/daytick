// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayHistoryModelAdapter extends TypeAdapter<DayHistoryModel> {
  @override
  final int typeId = 1;

  @override
  DayHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayHistoryModel(
      dateLabel: fields[0] as String,
      tasks: (fields[1] as List).cast<RoutineTaskModel>(),
      progressPercent: fields[2] as int,
      perfectDay: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DayHistoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dateLabel)
      ..writeByte(1)
      ..write(obj.tasks)
      ..writeByte(2)
      ..write(obj.progressPercent)
      ..writeByte(3)
      ..write(obj.perfectDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
