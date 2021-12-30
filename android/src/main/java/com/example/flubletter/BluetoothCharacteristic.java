package com.example.flubletter;

import android.util.Log;

import com.polidea.rxandroidble2.RxBleDevice;

import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;
import io.reactivex.disposables.Disposable;

public class BluetoothCharacteristic {

    private RxBleDevice device;

    UUID characteristicUuid;

    private Disposable readDisposable;

    private Disposable writeDisposable;

    public void onCharacteristicRead(byte[] bytes, MethodChannel channel){
        readDisposable = device.establishConnection(false)
                .flatMapSingle(rxBleConnection -> rxBleConnection.readCharacteristic(characteristicUuid))
                .subscribe(
                        characteristicValue -> {
                            channel.invokeMethod("new-read", characteristicValue);
                        },
                        throwable -> {
                            onCharacteristicFailure(throwable);
                        }
                );
    }

    public void onCharacteristicWrite(byte[] data){
        writeDisposable = device.establishConnection(false)
                .flatMapSingle(rxBleConnection -> rxBleConnection.writeCharacteristic(characteristicUuid, data))
                .subscribe(
                        characteristicValue -> {
                        },
                        throwable -> {
                            onCharacteristicFailure(throwable);
                        }
                );
    }

    private void onCharacteristicFailure(Throwable throwable) {
        Log.e(getClass().getName(), "Characteristic error: ", throwable);
    }
}
