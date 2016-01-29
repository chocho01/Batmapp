package com.epsi.batmapp.serializable;

import com.epsi.batmapp.model.User;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * Created by arnaud on 21/01/16.
 */
public class UserSerializable implements Serializable{

    private ArrayList<User> users;

    public UserSerializable(ArrayList<User> listUser) {
        this.users = listUser;
    }

    public ArrayList<User> getUsers() {
        return this.users;
    }
}
