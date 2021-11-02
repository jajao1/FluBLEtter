package com.example.flubletter.BluetoothADM;

import android.app.Application;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class BluetoothStatus {

    private Application aplication;
    private BluetoothAdapter bluetoothAdapter;
    private BluetoothManager bluetoothManager;

    void initialize(){
        bluetoothManager = (BluetoothManager) aplication.getSystemService(Context.BLUETOOTH_SERVICE);
        bluetoothAdapter = bluetoothManager.getAdapter();
    }

    void enableBT(){
        if (bluetoothAdapter.isEnabled() == false)
            bluetoothAdapter.enable();
    }

    void disableBT(){
        if (bluetoothAdapter.isEnabled())
            bluetoothAdapter.disable();
    }


    boolean BTisOn(){
        return bluetoothAdapter.isEnabled();
    }
}
