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
    private String id;
    private Date date;
    private String sender;
    private Integer criticity;
    private Double distance;
    private String type;
    private LatLng coord;
    private String[] receiver;
    private Boolean police;
    private Boolean samu;
    private Boolean solved;

    public Alert() {
    }

    protected Alert(Parcel in) {
        id = in.readString();
        date = (java.util.Date) in.readSerializable();
        sender = in.readString();
        criticity = in.readInt();
        distance = in.readDouble();
        type = in.readString();
        coord = in.readParcelable(LatLng.class.getClassLoader());
        receiver = in.createStringArray();
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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

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

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
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

    public String[] getReceiver() {
        return receiver;
    }

    public void setReceiver(String[] receiver) {
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
        parcel.writeString(id);
        parcel.writeSerializable(date);
        parcel.writeString(sender);
        parcel.writeInt(criticity);
        parcel.writeDouble(distance);
        parcel.writeString(type);
        parcel.writeParcelable(coord, i);
        parcel.writeStringArray(receiver);
        parcel.writeValue(police);
        parcel.writeValue(samu);
        parcel.writeValue(solved);
    }
}
