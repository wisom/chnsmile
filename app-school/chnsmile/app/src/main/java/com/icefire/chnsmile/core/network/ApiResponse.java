package com.icefire.chnsmile.core.network;

public class ApiResponse<T> {
    public boolean success;
    public int code;
    public String message;
    public T body;
}
