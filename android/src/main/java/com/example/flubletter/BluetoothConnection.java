package com.example.flubletter;

import static com.example.flubletter.FlubletterPlugin.rxBleClient;

import android.util.Log;

import io.reactivex.disposables.CompositeDisposable;

import com.jakewharton.rx.ReplayingShare;
import com.polidea.rxandroidble2.RxBleConnection;
import com.polidea.rxandroidble2.RxBleDevice;

import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.Observable;
import io.reactivex.subjects.PublishSubject;


public class BluetoothConnection {

    private RxBleDevice device;

    private static final String TAG = "Flubletter";

    private RxBleConnection.RxBleConnectionState state;

    private Disposable disposable;

    private Disposable stateDisposable;

    private PublishSubject<Boolean> disconnectTriggerSubject = PublishSubject.create();

    private MethodChannel channel;

    private RxBleConnection BleConnection;

    private Observable<RxBleConnection> connectionObservable;

    private BluetoothCharacteristic bluetoothCharacteristic = new BluetoothCharacteristic();

    private void initConnect(String mac, MethodChannel channel){
        this.channel = channel;
        device = rxBleClient.getBleDevice(mac);
        onConnectState();
        connectionObservable = prepareConnectionObservable();
    }

    public void onConnectToDevice(String mac, boolean auto, MethodChannel channel) {
        initConnect(mac, channel);
        onConnectState();
        disposable = connectionObservable
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        rxBleConnection -> {
                            BleConnection =  rxBleConnection;
                        },
                        throwable -> {
                            onConnectionFailure(throwable);
                        }
                );
    }

    private Observable<RxBleConnection> prepareConnectionObservable() {
        return device
                .establishConnection(false)
                .takeUntil(disconnectTriggerSubject)
                .compose(ReplayingShare.instance());
    }

    private void triggerDisconnect() {
        disconnectTriggerSubject.onNext(true);
    }

    private void onConnectState(){
        stateDisposable = device.observeConnectionStateChanges()
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        connectionState -> {
                            state = connectionState;
                            channel.invokeMethod("new-state", connectionState());
                        },
                        throwable -> {
                            onConnectionFailure(throwable);
                        }
                );

    }

    public void onCharacteristicRead(UUID characteristicUuid){
        bluetoothCharacteristic.onCharacteristicRead(channel, characteristicUuid, connectionObservable);
    }

    public void onCharacteristicWrite(byte[] data, UUID characteristicUuid){
        bluetoothCharacteristic.onCharacteristicWrite(data, characteristicUuid, connectionObservable);
    }


    private Object connectionState(){
       switch (state){
           case CONNECTED:
           {
               return 1;
           }
           case DISCONNECTED:
           {
               return -1 ;
           }case CONNECTING:
           {
               return 0 ;
           }
           case DISCONNECTING:
           {
               return 2 ;
           }default: {
               return 11;
           }
       }
    }

    public void disconnect() {
        triggerDisconnect();
        disposable.dispose();
        stateDisposable.dispose();
    }


    private boolean isConnected() {
            return device.getConnectionState() == RxBleConnection.RxBleConnectionState.CONNECTED;
    }

    private void onConnectionFailure(Throwable throwable) {
        Log.e(TAG, "Connection error: ", throwable);
    }


}
