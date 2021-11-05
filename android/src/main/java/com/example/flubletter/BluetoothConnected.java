package com.example.flubletter;


import static com.example.flubletter.FlubletterPlugin.rxBleClient;

import com.polidea.rxandroidble2.RxBleDevice;

import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;
import io.reactivex.disposables.Disposable;

public class BluetoothConnected {

    static byte[] bytesToWrite;

    static UUID characteristicUuid;

    public static void onConnectToDevice(String  mac){
        RxBleDevice device = rxBleClient.getBleDevice(mac);
        Disposable disposable = device.establishConnection(true)
                .flatMapSingle(rxBleConnection -> rxBleConnection.readCharacteristic(characteristicUuid)
                        .doOnSuccess(bytes -> {
                            // Process read data.
                        })
                        .flatMap(bytes -> rxBleConnection.writeCharacteristic(characteristicUuid, bytesToWrite))
                )
                .subscribe(
                        writeBytes -> {
                            // Written data.
                        },
                        throwable -> {
                            // Handle an error here.
                        }
                );
        disposable.dispose();

    }


    void onConnectionState(RxBleDevice device){
        Disposable disposable = device.observeConnectionStateChanges()
                .subscribe(connectionState -> {
                        }
                );
        disposable.dispose();
    }

}
