package com.icefire.chnsmile.core;

/**
 * 默认的api返回格式
 */
public class DefaultResponse<T> {
    public int code;
    public String msg;
    public T data;

}
