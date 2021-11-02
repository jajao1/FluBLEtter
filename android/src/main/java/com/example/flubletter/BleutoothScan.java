package com.example.flubletter;

import android.content.Context;

import com.polidea.rxandroidble2.RxBleClient;
import com.polidea.rxandroidble2.RxBleDevice;
import com.polidea.rxandroidble2.scan.ScanSettings;

import org.reactivestreams.Subscription;

import java.util.UUID;

import io.reactivex.Observable;
import io.reactivex.disposables.Disposable;

public class BleutoothScan {

    private Context context;

    RxBleClient rxBleClient = RxBleClient.create(context);

    byte[] bytesToWrite;

    UUID characteristicUuid;

    boolean auto = false;
     
    public void scanDevices(){
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
                            // Process scan result here.
                        },
                        throwable -> {
                            // Handle an error here.
                        }
                );

// When done, just dispose.
        flowDisposable.dispose();
    }


}
