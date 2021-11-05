package com.example.flubletter.BluetoothADM;

import android.app.Application;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class BluetoothStatus {

    private static Application aplication;
    private static BluetoothAdapter bluetoothAdapter;
    private static BluetoothManager bluetoothManager;

    void initialize(){
        bluetoothManager = (BluetoothManager) aplication.getSystemService(Context.BLUETOOTH_SERVICE);
        bluetoothAdapter = bluetoothManager.getAdapter();
    }

   public static void enableBT(){
        if (bluetoothAdapter.isEnabled() == false)
            bluetoothAdapter.enable();
    }

    public static void disableBT(){
        if (bluetoothAdapter.isEnabled())
            bluetoothAdapter.disable();
    }


    public static boolean BTisOn(){
        return bluetoothAdapter.isEnabled();
    }
}
