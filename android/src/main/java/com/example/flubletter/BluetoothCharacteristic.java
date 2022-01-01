package com.example.flubletter;

import android.util.Log;

import com.polidea.rxandroidble2.RxBleConnection;
import com.polidea.rxandroidble2.RxBleDevice;

import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;
import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;

public class BluetoothCharacteristic {


    private Disposable readDisposable;

    private Disposable writeDisposable;

    public void onCharacteristicRead(MethodChannel channel, UUID characteristicUuid, Observable<RxBleConnection> connectionObservable){
        readDisposable = connectionObservable
                .flatMapSingle(rxBleConnection -> rxBleConnection.readCharacteristic(characteristicUuid))
        .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        characteristicValue -> {
                            channel.invokeMethod("new-read", characteristicValue);
                        },
                        throwable -> {
                            onCharacteristicFailure(throwable);
                        }
                );
    }

    public void onCharacteristicWrite(byte[] data, UUID characteristicUuid, Observable<RxBleConnection> connectionObservable){
        writeDisposable = connectionObservable
                .firstOrError()
                .flatMap(rxBleConnection -> rxBleConnection.writeCharacteristic(characteristicUuid, data))
                .observeOn(AndroidSchedulers.mainThread())
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
