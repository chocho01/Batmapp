package com.epsi.batmapp.serializer;

import android.content.Context;

import com.epsi.batmapp.R;
import com.epsi.batmapp.model.User;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

import java.lang.reflect.Type;

/**
 * Created by arnaud on 21/01/16.
 */
public class UserSerializer implements JsonSerializer<User>, JsonDeserializer<User> {


    private static String EMAIL="email";
    private static String PWD="password";
    private static String F_NAME="firstName";
    private static String L_NAME="lastName";

    @Override
    public JsonElement serialize(User user, Type typeOfSrc, JsonSerializationContext context) {
        JsonObject jsonUser = new JsonObject();
        jsonUser.add(EMAIL,new JsonPrimitive(user.getEmail()));
        jsonUser.add(PWD,new JsonPrimitive(user.getPassword()));
        jsonUser.add(F_NAME,new JsonPrimitive(user.getFirstName()));
        jsonUser.add(L_NAME,new JsonPrimitive(user.getLastName()));
        return jsonUser;
    }

    @Override
    public User deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        JsonObject jsonUser = json.getAsJsonObject();
        User user = new User();
        user.setEmail(jsonUser.get(EMAIL).getAsString());
        user.setPassword(jsonUser.get(PWD).getAsString());
        user.setFirstName(jsonUser.get(F_NAME).getAsString());
        user.setLastName(jsonUser.get(L_NAME).getAsString());
        return user;
    }
}
