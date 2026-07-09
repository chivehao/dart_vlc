import 'dart:ffi';
import 'package:ffi/ffi.dart';

base class DeviceStruct extends Struct {
  external Pointer<Utf8> name;
  external Pointer<Utf8> id;
}

/// Struct received from C with devices data.
base class DeviceList extends Struct {
  @Int32()
  external int size;
  external Pointer<DeviceStruct> devices;
}

typedef DevicesAllCXX = Pointer<DeviceList> Function(Handle object);
typedef DevicesAllDart = Pointer<DeviceList> Function(Object object);
