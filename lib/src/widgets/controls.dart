// This file is a part of dart_vlc (https://github.com/alexmercerind/dart_vlc)
//
// Copyright (C) 2021-2022 Hitesh Kumar Saini <saini123hitesh@gmail.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3 of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

// ignore_for_file: implementation_imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dart_vlc_ffi/src/device.dart';
import 'package:dart_vlc_ffi/src/player.dart';
import 'package:dart_vlc_ffi/src/player_state/player_state.dart';

class Control extends StatefulWidget {
  Control({
    Key? key,
    required this.child,
    required this.player,
    required this.showTimeLeft,
    required this.progressBarThumbRadius,
    required this.progressBarThumbGlowRadius,
    required this.progressBarActiveColor,
    required this.progressBarInactiveColor,
    required this.progressBarThumbColor,
    required this.progressBarThumbGlowColor,
    required this.progressBarTextStyle,
    required this.volumeActiveColor,
    required this.volumeInactiveColor,
    required this.volumeBackgroundColor,
    required this.volumeThumbColor,
    this.onFullScreenChange,
  }) : super(key: key);

  final Widget child;
  final Player player;
  final bool? showTimeLeft;
  final double? progressBarThumbRadius;
  final double? progressBarThumbGlowRadius;
  final Color? progressBarActiveColor;
  final Color? progressBarInactiveColor;
  final Color? progressBarThumbColor;
  final Color? progressBarThumbGlowColor;
  final TextStyle? progressBarTextStyle;
  final Color? volumeActiveColor;
  final Color? volumeInactiveColor;
  final Color? volumeBackgroundColor;
  final Color? volumeThumbColor;
  final Function? onFullScreenChange;

  @override
  ControlState createState() => ControlState();
}

class ControlState extends State<Control> with SingleTickerProviderStateMixin {
  bool _hideControls = true;
  bool _displayTapped = false;
  Timer? _hideTimer;
  late StreamSubscription<PlaybackState> playPauseStream;
  late AnimationController playPauseController;
  bool _isFullScreen = false;

  Player get player => widget.player;

  @override
  void initState() {
    super.initState();
    playPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    playPauseStream = player.playbackStream
        .listen((event) => setPlaybackMode(event.isPlaying));
    if (player.playback.isPlaying) playPauseController.forward();
  }

  @override
  void dispose() {
    playPauseStream.cancel();
    playPauseController.dispose();
    super.dispose();
  }

  void setPlaybackMode(bool isPlaying) {
    if (isPlaying) {
      playPauseController.forward();
    } else {
      playPauseController.reverse();
    }
    setState(() {});
  }

  void _updateFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      widget.onFullScreenChange?.call();
    });
  }

  List<String> _getTrackDesc(String trackDesc) {
    if (trackDesc == "" || !trackDesc.contains(":")) List.empty();
    return trackDesc.split(":");
  }

  int? _getTrackDescId(String trackDesc) {
    List<String> trackProps = _getTrackDesc(trackDesc);
    if (trackProps.isEmpty) return null;
    return int.parse(trackProps[0]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (player.playback.isPlaying) {
          if (_displayTapped) {
            setState(() {
              _hideControls = true;
              _displayTapped = false;
            });
          } else {
            _cancelAndRestartTimer();
          }
        } else {
          setState(() => _hideControls = true);
        }
      },
      child: MouseRegion(
        onHover: (_) => _cancelAndRestartTimer(),
        child: AbsorbPointer(
          absorbing: _hideControls,
          child: Stack(
            children: [
              widget.child,
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _hideControls ? 0.0 : 1.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xCC000000),
                            Color(0x00000000),
                            Color(0x00000000),
                            Color(0x00000000),
                            Color(0x00000000),
                            Color(0x00000000),
                            Color(0xCC000000),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: 60, right: 20, left: 20),
                        child: StreamBuilder<PositionState>(
                          stream: player.positionStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<PositionState> snapshot) {
                            final durationState = snapshot.data;
                            final progress =
                                durationState?.position ?? Duration.zero;
                            final total =
                                durationState?.duration ?? Duration.zero;
                            return Theme(
                              data: ThemeData.dark(),
                              child: ProgressBar(
                                progress: progress,
                                total: total,
                                barHeight: 3,
                                progressBarColor: widget.progressBarActiveColor,
                                thumbColor: widget.progressBarThumbColor,
                                baseBarColor: widget.progressBarInactiveColor,
                                thumbGlowColor:
                                    widget.progressBarThumbGlowColor,
                                thumbRadius:
                                    widget.progressBarThumbRadius ?? 10.0,
                                thumbGlowRadius:
                                    widget.progressBarThumbGlowRadius ?? 30.0,
                                timeLabelLocation: TimeLabelLocation.sides,
                                timeLabelType: widget.showTimeLeft!
                                    ? TimeLabelType.remainingTime
                                    : TimeLabelType.totalTime,
                                timeLabelTextStyle: widget.progressBarTextStyle,
                                onSeek: (duration) {
                                  player.seek(duration);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    StreamBuilder<CurrentState>(
                      stream: widget.player.currentStream,
                      builder: (context, snapshot) {
                        return Positioned(
                          left: 0,
                          right: 0,
                          bottom: 10,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if ((snapshot.data?.medias.length ?? 0) > 1)
                                IconButton(
                                  color: Colors.white,
                                  iconSize: 30,
                                  icon: Icon(Icons.skip_previous),
                                  onPressed: () => player.previous(),
                                ),
                              SizedBox(width: 50),
                              IconButton(
                                  color: Colors.white,
                                  iconSize: 30,
                                  icon: Icon(Icons.replay_10),
                                  onPressed: () {
                                    int positionInMilliseconds = player.position
                                            .position?.inMilliseconds ??
                                        0;
                                    if (!(positionInMilliseconds - 10000)
                                        .isNegative) {
                                      positionInMilliseconds -= 10000;
                                    }
                                    player.seek(Duration(
                                        milliseconds: positionInMilliseconds));
                                    setState(() {});
                                  }),
                              SizedBox(width: 20),
                              IconButton(
                                color: Colors.white,
                                iconSize: 30,
                                icon: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: playPauseController),
                                onPressed: () {
                                  if (player.playback.isPlaying) {
                                    player.pause();
                                    playPauseController.reverse();
                                  } else {
                                    player.play();
                                    playPauseController.forward();
                                  }
                                },
                              ),
                              SizedBox(width: 20),
                              IconButton(
                                  color: Colors.white,
                                  iconSize: 30,
                                  icon: Icon(Icons.forward_10),
                                  onPressed: () {
                                    int durationInMilliseconds = player.position
                                            .duration?.inMilliseconds ??
                                        0;
                                    int positionInMilliseconds = player.position
                                            .position?.inMilliseconds ??
                                        1;
                                    if ((positionInMilliseconds + 10000) <=
                                        durationInMilliseconds) {
                                      positionInMilliseconds += 10000;
                                      player.seek(Duration(
                                          milliseconds:
                                              positionInMilliseconds));
                                      setState(() {});
                                    }
                                  }),
                              SizedBox(width: 50),
                              if ((snapshot.data?.medias.length ?? 0) > 1)
                                IconButton(
                                  color: Colors.white,
                                  iconSize: 30,
                                  icon: Icon(Icons.skip_next),
                                  onPressed: () => player.next(),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 15,
                      bottom: 12.5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          VolumeControl(
                            player: player,
                            thumbColor: widget.volumeThumbColor,
                            inactiveColor: widget.volumeInactiveColor,
                            activeColor: widget.volumeActiveColor,
                            backgroundColor: widget.volumeBackgroundColor,
                          ),
                          PopupMenuButton(
                            iconSize: 24,
                            tooltip: "Audio Devices",
                            icon: Icon(Icons.speaker, color: Colors.white),
                            onSelected: (Device device) {
                              player.setDevice(device);
                              setState(() {});
                            },
                            itemBuilder: (context) {
                              return Devices.all
                                  .map(
                                    (device) => PopupMenuItem(
                                      child: Text(device.name,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                      value: device,
                                    ),
                                  )
                                  .toList();
                            },
                          ),
                          PopupMenuButton(
                            iconSize: 24,
                            tooltip: "音频轨道",
                            icon: Icon(Icons.audiotrack, color: Colors.white),
                            onSelected: (String trackDesc) {
                              int? id = _getTrackDescId(trackDesc);
                              if (id == null) return;
                              player.setAudioTrack(id);
                            },
                            itemBuilder: (context) {
                              final audioTrack = player.audioTrack();
                              return player.audioTrackDescription()
                                  .where((track)=>!track.startsWith("-1"))
                                  .map(
                                    (track) => PopupMenuItem(
                                      child: Text(track,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: audioTrack == _getTrackDescId(track) ? Colors.lightBlueAccent : Colors.black
                                          )),
                                      value: track,
                                    ),
                                  )
                                  .toList();
                            },
                          ),
                          PopupMenuButton(
                            iconSize: 24,
                            tooltip: "字幕轨道",
                            icon: Icon(Icons.subtitles, color: Colors.white),
                            onSelected: (String trackDesc) {
                              if (trackDesc == "" || !trackDesc.contains(":")) return;
                              var trackProps = trackDesc.split(":");
                              var trackId = int.parse(trackProps[0]);
                              player.setSpu(trackId);
                            },
                            itemBuilder: (context) {
                              final spu = player.spu();
                              return player.spuTrackDescription()
                                  .map(
                                    (track) => PopupMenuItem(
                                      child: Text(track,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                              color: track.startsWith(spu.toString()) ? Colors.lightBlueAccent : Colors.black
                                          )),
                                      value: track,
                                    ),
                                  )
                                  .toList();
                            },
                          ),
                          // full screen
                          IconButton(
                            iconSize: 24,
                            icon: const Icon(Icons.fullscreen, color: Colors.white),
                            onPressed: () {
                              // 全屏按钮的逻辑
                              _updateFullScreen();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();

    if (mounted) {
      _startHideTimer();

      setState(() {
        _hideControls = false;
        _displayTapped = true;
      });
    }
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _hideControls = true;
          _displayTapped = false;
        });
      }
    });
  }
}

class VolumeControl extends StatefulWidget {
  final Player player;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;
  final Color? thumbColor;

  const VolumeControl({
    required this.player,
    required this.activeColor,
    required this.inactiveColor,
    required this.backgroundColor,
    required this.thumbColor,
    Key? key,
  }) : super(key: key);

  @override
  VolumeControlState createState() => VolumeControlState();
}

class VolumeControlState extends State<VolumeControl> {
  double volume = 0.5;
  bool _showVolume = false;
  double unmutedVolume = 0.5;

  Player get player => widget.player;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          duration: Duration(milliseconds: 250),
          opacity: _showVolume ? 1 : 0,
          child: AbsorbPointer(
            absorbing: !_showVolume,
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _showVolume = true);
              },
              onExit: (_) {
                setState(() => _showVolume = false);
              },
              child: Container(
                width: 60,
                height: 250,
                child: Card(
                  color: widget.backgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: widget.activeColor,
                        inactiveTrackColor: widget.inactiveColor,
                        thumbColor: widget.thumbColor,
                      ),
                      child: Slider(
                        min: 0.0,
                        max: 1.0,
                        value: player.general.volume,
                        onChanged: (volume) {
                          player.setVolume(volume);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        MouseRegion(
          onEnter: (_) {
            setState(() => _showVolume = true);
          },
          onExit: (_) {
            setState(() => _showVolume = false);
          },
          child: IconButton(
            color: Colors.white,
            onPressed: () => muteUnmute(),
            icon: Icon(getIcon()),
          ),
        ),
      ],
    );
  }

  IconData getIcon() {
    if (player.general.volume > .5) {
      return Icons.volume_up_sharp;
    } else if (player.general.volume > 0) {
      return Icons.volume_down_sharp;
    } else {
      return Icons.volume_off_sharp;
    }
  }

  void muteUnmute() {
    if (player.general.volume > 0) {
      unmutedVolume = player.general.volume;
      player.setVolume(0);
    } else {
      player.setVolume(unmutedVolume);
    }
    setState(() {});
  }
}
