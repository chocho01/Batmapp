package com.epsi.batmapp.model;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.android.gms.maps.model.LatLng;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by arnaud on 20/01/16.
 */
public class Alert implements Parcelable {

    private Date date;
    private String sender;
    private Integer criticity;
    private String type;
    private LatLng coord;
    private int[] receiver;
    private Boolean police;
    private Boolean samu;
    private Boolean solved;

    public Alert() {
    }

    public Alert(String sender, String type) {
        this.date = new Date();
        this.type = type;
        this.sender = sender;
        this.coord = new LatLng(45,5);
        this.criticity = 3;
        this.receiver = new int[]{};
        this.police = false;
        this.samu = false;
        this.solved = false;
    }

    protected Alert(Parcel in) {
        date = (java.util.Date) in.readSerializable();
        sender = in.readString();
        criticity = in.readInt();
        type = in.readString();
        coord = in.readParcelable(LatLng.class.getClassLoader());
        receiver = in.createIntArray();
        police = (Boolean) in.readValue(null);
        samu = (Boolean) in.readValue(null);
        solved = (Boolean) in.readValue(null);
    }

    public static final Creator<Alert> CREATOR = new Creator<Alert>() {
        @Override
        public Alert createFromParcel(Parcel in) {
            return new Alert(in);
        }

        @Override
        public Alert[] newArray(int size) {
            return new Alert[size];
        }
    };

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public Integer getCriticity() {
        return criticity;
    }

    public void setCriticity(Integer criticity) {
        this.criticity = criticity;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public LatLng getCoord() {
        return coord;
    }

    public void setCoord(LatLng coord) {
        this.coord = coord;
    }

    public int[] getReceiver() {
        return receiver;
    }

    public void setReceiver(int[] receiver) {
        this.receiver = receiver;
    }

    public Boolean getPolice() {
        return police;
    }

    public void setPolice(Boolean police) {
        this.police = police;
    }

    public Boolean getSamu() {
        return samu;
    }

    public void setSamu(Boolean samu) {
        this.samu = samu;
    }

    public Boolean isSolved() {
        return solved;
    }

    public void setSolved(Boolean solved) {
        this.solved = solved;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeSerializable(date);
        parcel.writeString(sender);
        parcel.writeInt(criticity);
        parcel.writeString(type);
        parcel.writeParcelable(coord,i);
        parcel.writeIntArray(receiver);
        parcel.writeValue(police);
        parcel.writeValue(samu);
        parcel.writeValue(solved);
    }
}
