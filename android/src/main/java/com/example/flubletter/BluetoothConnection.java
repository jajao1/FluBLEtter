package com.example.flubletter;

import static com.example.flubletter.FlubletterPlugin.rxBleClient;

import android.util.Log;

import com.polidea.rxandroidble2.RxBleConnection;
import com.polidea.rxandroidble2.RxBleDevice;

import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;
import io.reactivex.disposables.Disposable;
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers;


public class BluetoothConnection {

    private RxBleDevice device;

    private static final String TAG = "Flubletter";

    private RxBleConnection.RxBleConnectionState state;

    private Disposable disposable;

    private Disposable stateDisposable;

    UUID characteristicUuid;

    private BluetoothCharacteristic bluetoothCharacteristic = new BluetoothCharacteristic();

    private MethodChannel channel;

    RxBleConnection BleConnection;

    private void onConnectToDevice(String mac, boolean auto) {
        device = rxBleClient.getBleDevice(mac);
        disposable = device.establishConnection(auto) // <-- autoConnect flag
                .subscribe(
                        rxBleConnection -> {
                            BleConnection =  rxBleConnection;
                        },
                        throwable -> {
                            onConnectionFailure(throwable);
                        }
                );
    }

    private void onConnectState(){
        stateDisposable = device.observeConnectionStateChanges()
                .subscribe(
                        connectionState -> {
                            state = connectionState;
                        },
                        throwable -> {
                            onConnectionFailure(throwable);
                        }
                );

    }


    private float connectionState(){
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
        disposable.dispose();
    }


    private boolean isConnected() {
            return device.getConnectionState() == RxBleConnection.RxBleConnectionState.CONNECTED;

    }

    private void onConnectionFailure(Throwable throwable) {
        Log.e(TAG, "Connection error: ", throwable);
    }


}
