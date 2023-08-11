package com.icefire.chnsmile.core.network.cache;

import androidx.annotation.NonNull;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import java.io.Serializable;

/*
 * Created by chao.fan on 2020/5/5.
 */
@Entity(tableName = "cache")
public class Cache implements Serializable {

    @PrimaryKey(autoGenerate = false)
    @NonNull
    public String key;

    public byte[] data;
}
