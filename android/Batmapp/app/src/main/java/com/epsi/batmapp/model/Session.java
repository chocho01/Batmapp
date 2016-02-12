package com.epsi.batmapp.model;

import android.content.Context;

/**
 * Created by arnaud on 12/02/16.
 */
public class Session {

    private static Session instance;
    private User userConnected;

    public static Session getInstance(User user) {
        if (instance == null) {
            instance = new Session(user);
        }
        return instance;
    }

    public Session (User user){
        this.userConnected = new User(user);
    }

    public User getUserConnected(){
        return userConnected;
    }

}
