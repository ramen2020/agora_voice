import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_voice_example/src/utils/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// App state
class _MyAppState extends State<MyApp> {
  bool _joined = false;
  int _remoteUid = null;
  bool _switch = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Initialize the app
  Future<void> initPlatformState() async {
    // Get microphone permission
    await PermissionHandler().requestPermissions(
      [PermissionGroup.microphone],
    );

    // Create RTC client instance
    RtcEngineConfig config = RtcEngineConfig(APP_ID);
    
    // RtcEngineインスタンスを作成し、接続領域を指定します。
    var engine = await RtcEngine.createWithConfig(config);
    // Define event handler
    engine.setEventHandler(RtcEngineEventHandler(
        // ローカルユーザーが指定された時に発生
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess ${channel} ${uid}');
      setState(() {
        _joined = true;
      });
    }, // リモートユーザー（ChannelProfile.Communication）/ホスト（ChannelProfile.LiveBroadcasting）がチャネルに参加したときに発生します
      userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _remoteUid = uid;
      });
    }, // リモートユーザー（ChannelProfile.Communication）/ホスト（ChannelProfile.LiveBroadcasting）がチャネルを離れるときに発生します
      userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline ${uid}');
      setState(() {
        _remoteUid = null;
      });
    }));
    // Join channel 
    await engine.joinChannel(Token, '466yoikobdntnttnrtntnjt', null, 0);
  }

  // Create a simple chat UI
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agora Audio quickstart',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Agora Audio quickstart'),
        ),
        body: Center(
          child: Text('Please chat!'),
        ),
      ),
    );
  }
}
