package com.example.flubletter;

import com.polidea.rxandroidble2.RxBleDevice;

import java.util.UUID;

import io.reactivex.disposables.Disposable;

public class Connected {

    byte[] bytesToWrite;

    UUID characteristicUuid;

    void onConnectToDevice(RxBleDevice device){
        Disposable disposable = device.establishConnection(false)
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
