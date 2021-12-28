package com.example.flubletter;

import android.app.Application;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class BluetoothStatus {

    private static Application aplication;
    private static BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
    private static BluetoothManager bluetoothManager;


    void initialize(){
        bluetoothManager = (BluetoothManager) aplication.getSystemService(Context.BLUETOOTH_SERVICE);
        bluetoothAdapter = bluetoothManager.getAdapter();
    }

   public static boolean enableBT(){
       return bluetoothAdapter.enable();
    }

    public static boolean disableBT(){
           return bluetoothAdapter.disable();
    }


    public boolean BTisOn(){
        return bluetoothAdapter.isEnabled();
    }
}
