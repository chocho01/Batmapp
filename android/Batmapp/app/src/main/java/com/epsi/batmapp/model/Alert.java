package com.epsi.batmapp.model;

import com.google.android.gms.maps.model.LatLng;

import java.util.Date;

/**
 * Created by arnaud on 20/01/16.
 */
public class Alert {

    private Date date;
    private String sender;
    private Integer criticity;
    private String type;
    private LatLng coord;
    private Integer[] receiver;
    private Boolean police;
    private Boolean samu;
    private Boolean solved;

    public Alert() {
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

    public Integer[] getReceiver() {
        return receiver;
    }

    public void setReceiver(Integer[] receiver) {
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
}
