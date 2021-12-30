package com.example.flubletter;


import android.app.Application;
import android.content.Context;

import androidx.annotation.NonNull;

import com.polidea.rxandroidble2.RxBleClient;
import com.polidea.rxandroidble2.scan.ScanFilter;
import com.polidea.rxandroidble2.scan.ScanSettings;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.reactivex.disposables.Disposable;

/**
 * Service for managing connection and data communication with a GATT server hosted on a
 * given Bluetooth LE device.
 */
 public class FlubletterPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    public MethodChannel channel;

    private static Context context;

    static RxBleClient rxBleClient;

    private static Application application;

    BluetoothStatus bluetoothStatus = new BluetoothStatus();

    private static final String TAG = "Flubletter";

    private static UUID uuid = UUID.fromString("4fafc201-1fb5-459e-8fcc-c5c9c331914b");


    private Disposable scanDisposable;

    boolean auto = false;


    public static void registerWith(PluginRegistry.Registrar registrar) {
        context = registrar.activity().getApplicationContext();
        application = registrar.activity().getApplication();
    }



    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flubletter");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getPlatformVersion": {
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            }
            case "btison": {
                result.success(bluetoothStatus.BTisOn());
                break;
            }
            case "enable-bt": {
                result.success(bluetoothStatus.enableBT());
                break;
            }
            case "disable-bt": {
                result.success(bluetoothStatus.disableBT());
                break;
            }
            case "scan-bt": {
                scanDevices(channel);
                result.success("scan begin");
                break;
            }
            case "connect-device": {
                String mac = call.argument("mac");
                onConnectToDevice(mac);
                break;
            }
            default: {
                result.notImplemented();
                break;
            }

        }
    }



    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        context = binding.getActivity().getApplicationContext();
        application = binding.getActivity().getApplication();
        rxBleClient = RxBleClient.create(binding.getActivity().getApplicationContext());

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    private void onConnectToDevice(String mac) {
    }


    private void scanDevices(MethodChannel channel) {
        scanDisposable = rxBleClient.scanBleDevices(
                new ScanSettings.Builder()
                        .setScanMode(ScanSettings.SCAN_MODE_BALANCED)
                        .setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES)
                        .build(),
                new ScanFilter.Builder()
//                            .setDeviceAddress("B4:99:4C:34:DC:8B")
                        // add custom filters if needed
                        .build()
        )
                .subscribe(
                        scanResult -> {
                            List<Object> list = new ArrayList<Object>();
                                list.add(scanResult.getBleDevice().getMacAddress());
                                list.add(scanResult.getBleDevice().getName());
                                list.add(scanResult.getRssi());
                                channel.invokeMethod("new-scanned", list);
                        },
                        throwable -> {
                            // Handle an error here.
                        }
                );
    }
}