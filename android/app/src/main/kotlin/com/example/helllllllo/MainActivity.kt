package com.example.helllllllo

// In your Android activity or service
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL_NAME = "com.example.helllllllo/volume";
    private VolumeButtonReceiver volumeButtonReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        registerVolumeButtonReceiver();
    }

    @Override
    protected void onDestroy() {
        unregisterVolumeButtonReceiver();
        super.onDestroy();
    }

    private void registerVolumeButtonReceiver() {
        volumeButtonReceiver = new VolumeButtonReceiver();
        IntentFilter filter = new IntentFilter(AudioManager.ACTION_VOLUME_CHANGED);
        registerReceiver(volumeButtonReceiver, filter);
    }

    private void unregisterVolumeButtonReceiver() {
        unregisterReceiver(volumeButtonReceiver);
    }

    private class VolumeButtonReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(AudioManager.ACTION_VOLUME_CHANGED)) {
                int volume = intent.getIntExtra(AudioManager.EXTRA_VOLUME_STREAM_VALUE, -1);
                int maxVolume = intent.getIntExtra(AudioManager.EXTRA_VOLUME_STREAM_MAX, -1);
                if (volume == 0 && maxVolume > 0) {
                    new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL_NAME)
                    .invokeMethod("volumeDownPressed", null);
                }
            }
        }
    }
}