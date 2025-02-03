// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShippingAddressModelAdapter extends TypeAdapter<ShippingAddressModel> {
  @override
  final int typeId = 2;

  @override
  ShippingAddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShippingAddressModel(
      shippingTo: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      country: fields[3] as String,
      address: fields[4] as String,
      city: fields[5] as String,
      state: fields[6] as String,
      postalCode: fields[7] as String,
      phoneNumber: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShippingAddressModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.shippingTo)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.postalCode)
      ..writeByte(8)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingAddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
