package com.example.flubletter;


import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.example.flubletter.BluetoothADM.BluetoothStatus;
import com.polidea.rxandroidble2.RxBleClient;
import com.polidea.rxandroidble2.scan.ScanSettings;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.Observable;
import io.reactivex.disposables.Disposable;

/**
 * Service for managing connection and data communication with a GATT server hosted on a
 * given Bluetooth LE device.
 */
 class FlubletterPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {


    public MethodChannel channel;

    private static Context context;

    static RxBleClient rxBleClient = RxBleClient.create(context);

    byte[] bytesToWrite;

    UUID characteristicUuid;

    boolean auto = false;




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
            case "bt-ison": {
                result.success(BluetoothStatus.BTisOn());
                break;
            }
            case "enable-bt": {
                BluetoothStatus.enableBT();
                break;
            }
            case "disable-bt": {
                BluetoothStatus.disableBT();
                break;
            }
            case "scan-bt": {
                scanDevices(channel);
                break;
            }
            case "connect-device": {
                String mac = call.argument("mac");
                BluetoothConnected.onConnectToDevice(mac);
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

    public static void scanDevices(MethodChannel channel){
        Disposable flowDisposable = rxBleClient.observeStateChanges()
                .switchMap(state -> { // switchMap makes sure that if the state will change the rxBleClient.scanBleDevices() will dispose and thus end the scan
                    switch (state) {

                        case READY:
                            // everything should work
                            return rxBleClient.scanBleDevices(
                                    new ScanSettings.Builder()
                                            // .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY) // change if needed
                                            // .setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES) // change if needed
                                            .build()
                            );
                        case BLUETOOTH_NOT_AVAILABLE:
                            // basically no functionality will work here
                        case LOCATION_PERMISSION_NOT_GRANTED:
                            // scanning and connecting will not work
                        case BLUETOOTH_NOT_ENABLED:
                            // scanning and connecting will not work
                        case LOCATION_SERVICES_NOT_ENABLED:
                            // scanning will not work
                        default:
                            return Observable.empty();
                    }
                })
                .subscribe(
                        rxBleScanResult -> {
                            List<Object > list = new ArrayList<>();
                            list.add(rxBleScanResult.getBleDevice().getMacAddress());
                            list.add(rxBleScanResult.getBleDevice().getName());
                            list.add(rxBleScanResult.getRssi());
                            channel.invokeMethod("new-scanned", list);
                        },
                        throwable -> {
                            // Handle an error here.
                        }
                );

// When done, just dispose.
        flowDisposable.dispose();
    }


}