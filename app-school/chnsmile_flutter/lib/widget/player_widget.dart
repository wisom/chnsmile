import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/notifications.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  final String url;
  StreamController streamController;
  final Function onTap;

  PlayerWidget(this.url, {Key key, this.streamController, this.onTap}) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState(url);
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  AudioPlayer _audioPlayer;
  PlayerState _audioPlayerState;
  PlayerMode mode;

  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.STOPPED;
  PlayingRoute _playingRouteState = PlayingRoute.SPEAKERS;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription<PlayerControlCommand> _playerControlCommandSubscription;

  bool get _isPlaying => _playerState == PlayerState.PLAYING;

  bool get _isPaused => _playerState == PlayerState.PAUSED;

  String get _durationText => _duration.toString().split('.').first ?? '';

  String get _positionText => _position.toString().split('.').first ?? '';

  _PlayerWidgetState(this.url);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _playerCompleteSubscription.cancel();
    _playerErrorSubscription.cancel();
    _playerControlCommandSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                if (widget.onTap == null) {
                  if (_isPlaying) {
                    _pause();
                  } else {
                    if (widget.streamController != null) {
                      widget.streamController.add(_audioPlayer);
                    }
                    _play();
                  }
                } else {
                  widget.onTap();
                }
              },
              child: _buildIcon()),
          Expanded(
              child: Slider(
                  inactiveColor: Colors.black12,
                  value: (_position != null &&
                          _duration != null &&
                          _position.inMilliseconds > 0 &&
                          _position.inMilliseconds < _duration.inMilliseconds)
                      ? _position.inMilliseconds / _duration.inMilliseconds
                      : 0.0,
                  onChanged: (v) {
                    final duration = _duration;
                    print("object duraction: $duration");
                    if (duration == null) {
                      return;
                    }
                    final Position = v * duration.inMilliseconds;
                    _audioPlayer.seek(Duration(milliseconds: Position.round()));
                  })),
          Text(
              _position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                      ? _durationText
                      : '',
              style: const TextStyle(fontSize: 13, color: Colors.grey))
        ],
      ),
    );
  }

  void _initAudioPlayer() {
    mode = PlayerMode.MEDIA_PLAYER;
    _audioPlayer = AudioPlayer(mode: mode);
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      print("duration: $duration");
      setState(() => _duration = duration);
    });

    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.STOPPED;
        _duration = const Duration();
        _position = const Duration();
      });
    });

    _playerControlCommandSubscription =
        _audioPlayer.notificationService.onPlayerCommand.listen((command) {
      print('player command: $command');
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      String payerId = _audioPlayer.playerId;
      print('player state: $payerId  $state');
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (mounted) {
        print('player  state1: $state');
        setState(() => _audioPlayerState = state);
      }
    });

    _playingRouteState = PlayingRoute.SPEAKERS;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      setState(() => _playerState = PlayerState.PLAYING);
    }
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = PlayerState.PAUSED);
    }
    return result;
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1) {
      setState(() => _playingRouteState = _playingRouteState.toggle());
    }
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        _position = const Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.STOPPED);
  }

  _buildIcon() {
    if (_isPlaying) {
      return const Icon(Icons.pause_circle_outlined,
          size: 26, color: Colors.lightBlue);
    } else {
      return const Icon(Icons.play_circle_outline,
          size: 26, color: Colors.lightBlue);
    }
  }
}
