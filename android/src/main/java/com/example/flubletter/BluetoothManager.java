package com.example.flubletter;

import com.polidea.rxandroidble2.RxBleConnection;
import com.polidea.rxandroidble2.RxBleDevice;


public class BluetoothManager {


    private RxBleConnection BleConnection;

    private RxBleDevice device;

    public void requestMtu(int size){
        BleConnection.requestMtu(size);
    }

    public int getMtu(){
        return BleConnection.getMtu();
    }

    public String getUUID(){
     return device.getBluetoothDevice().getUuids().toString();
    }



}
