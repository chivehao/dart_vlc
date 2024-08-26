import 'dart:ffi';
import 'package:dart_vlc_ffi/dart_vlc_ffi.dart';
import 'package:ffi/ffi.dart';

typedef CommonFreeStrCXX = Void Function(Pointer<Utf8> str);
typedef CommonFreeStrDart = void Function(Pointer<Utf8> str);

typedef PlayerCreateCXX = Void Function(
    Int32 id,
    Int32 videoHeight,
    Int32 videoWidth,
    Int32 commandlineArgumentsCount,
    Pointer<Pointer<Utf8>> commandlineArguments);
typedef PlayerCreateDart = void Function(
    int id,
    int videoHeight,
    int videoWidth,
    int commandlineArgumentsCount,
    Pointer<Pointer<Utf8>> commandlineArguments);
typedef PlayerDisposeCXX = Void Function(Int32 id);
typedef PlayerDisposeDart = void Function(int id);
typedef PlayerOpenCXX = Void Function(
    Int32 id, Int32 autoStart, Pointer<Pointer<Utf8>> source, Int32 sourceSize);
typedef PlayerOpenDart = void Function(
    int id, int autoStart, Pointer<Pointer<Utf8>> source, int sourceSize);
typedef PlayerTriggerCXX = Void Function(Int32 id);
typedef PlayerTriggerDart = void Function(int id);
typedef PlayerJumpToIndexCXX = Void Function(Int32 id, Int32 index);
typedef PlayerJumpToIndexDart = void Function(int id, int index);
typedef PlayerSeekCXX = Void Function(Int32 id, Int32 position);
typedef PlayerSeekDart = void Function(int id, int position);
typedef PlayerSetVolumeCXX = Void Function(Int32 id, Float volume);
typedef PlayerSetVolumeDart = void Function(int id, double volume);
typedef PlayerSetRateCXX = Void Function(Int32 id, Float volume);
typedef PlayerSetRateDart = void Function(int id, double volume);
typedef PlayerSetUserAgentCXX = Void Function(
    Int32 id, Pointer<Utf8> userAgent);
typedef PlayerSetUserAgentDart = void Function(int id, Pointer<Utf8> userAgent);
typedef PlayerSetEqualizerCXX = Void Function(Int32 id, Int32 equalizerId);
typedef PlayerSetEqualizerDart = void Function(int id, int equalizerId);
typedef PlayerSetDeviceCXX = Void Function(
    Int32 id, Pointer<Utf8> deviceId, Pointer<Utf8> deviceName);
typedef PlayerSetDeviceDart = void Function(
    int id, Pointer<Utf8> deviceId, Pointer<Utf8> deviceName);
typedef PlayerSetPlaylistModeCXX = Void Function(Int32 id, Pointer<Utf8> mode);
typedef PlayerSetPlaylistModeDart = void Function(int id, Pointer<Utf8> mode);
typedef PlayerAddCXX = Void Function(
    Int32 id, Pointer<Utf8> type, Pointer<Utf8> resource);
typedef PlayerAddDart = void Function(
    int id, Pointer<Utf8> type, Pointer<Utf8> resource);
typedef PlayerRemoveCXX = Void Function(Int32 id, Int32 index);
typedef PlayerRemoveDart = void Function(int id, int index);
typedef PlayerInsertCXX = Void Function(
    Int32 id, Int32 index, Pointer<Utf8> type, Pointer<Utf8> resource);
typedef PlayerInsertDart = void Function(
    int id, int index, Pointer<Utf8> type, Pointer<Utf8> resource);
typedef PlayerMoveCXX = Void Function(
    Int32 id, Int32 initialIndex, Int32 finalIndex);
typedef PlayerMoveDart = void Function(
    int id, int initialIndex, int finalIndex);
typedef PlayerTakeSnapshotCXX = Void Function(
    Int32 id, Pointer<Utf8> filePath, Int32 width, Int32 height);
typedef PlayerTakeSnapshotDart = void Function(
    int id, Pointer<Utf8> filePath, int width, int height);
typedef PlayerSetAudioTrackCXX = Void Function(Int32 id, Int32 index);
typedef PlayerSetAudioTrackDart = void Function(int id, int index);
typedef PlayerGetAudioTrackCountCXX = Int32 Function(Int32 id);
typedef PlayerGetAudioTrackCountDart = int Function(int id);
typedef PlayerAddSlaveCXX = Bool Function(Int32 id, Int32 mediaSlaveType, Pointer<Utf8> uri, Bool select);
typedef PlayerAddSlaveDart = bool Function(int id, int mediaSlaveType, Pointer<Utf8> uri, bool select);
typedef PlayerSetHWNDCXX = Int32 Function(Int32 id, Int64 hwnd);
typedef PlayerSetHWNDDart = int Function(int id, int hwnd);
typedef PlayerAudioTrackDescriptionCXX = Pointer<Utf8> Function(Int32 id);
typedef PlayerAudioTrackDescriptionDart = Pointer<Utf8> Function(int id);
typedef PlayerSpuTrackDescriptionCXX = Pointer<Utf8> Function(Int32 id);
typedef PlayerSpuTrackDescriptionDart = Pointer<Utf8> Function(int id);
typedef PlayerSetSpuCXX = Int32 Function(Int32 id, Int32 iSpu);
typedef PlayerSetSpuDart = int Function(int id, int iSpu);
typedef PlayerSpuCXX = Int32 Function(Int32 id);
typedef PlayerSpuDart = int Function(int id);
typedef PlayerAudioTrackCXX = Int32 Function(Int32 id);
typedef PlayerAudioTrackDart = int Function(int id);
