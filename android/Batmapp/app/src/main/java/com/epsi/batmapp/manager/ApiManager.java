package com.epsi.batmapp.manager;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;


import com.android.volley.Request;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.epsi.batmapp.R;
import com.epsi.batmapp.activity.Authentication;
import com.epsi.batmapp.activity.ListAlert;
import com.epsi.batmapp.helper.MultipartRequest;
import com.epsi.batmapp.model.Alert;
import com.epsi.batmapp.model.User;
import com.epsi.batmapp.serializer.AlertSerializer;
import com.epsi.batmapp.serializer.UserSerializer;
import com.google.android.gms.maps.model.LatLng;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;


/**
 * Created by arnaud on 04/02/16.
 */
public class ApiManager {

    private Context context;
    private boolean connected;
    private SharedPreferences shared;

    public ApiManager(Context context) {
        this.context = context;
    }

    public void createAlertAPI(Alert alert){
        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(Alert.class, new AlertSerializer());
        gsonBuilder.setPrettyPrinting();
        Gson gson = gsonBuilder.create();

        String jsonString = gson.toJson(alert);
        String url = context.getString(R.string.api_create_alert_url);

        JSONObject jsonAlert = null;
        try {
            jsonAlert = new JSONObject(jsonString);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JsonObjectRequest jsObjRequest = new JsonObjectRequest
                (Request.Method.POST, url, jsonAlert, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Intent goToListAlert= new Intent(context, ListAlert.class);
                        context.startActivity(goToListAlert);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        error.printStackTrace();
                        displayAlertMessage(context.getString(R.string.error_registration_title),
                                context.getString(R.string.error_registration_server));
                    }
                });
        Volley.newRequestQueue(context).add(jsObjRequest);
    }

    public void createVocalAlertAPI(ArrayList<String> wordsRecognize){

        String url = context.getString(R.string.api_create_vocal_alert_url);
        JSONArray wordsArray = new JSONArray(Arrays.asList(wordsRecognize));
        JSONObject words = new JSONObject();
        try {
            words.put("msg",wordsArray);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsObjRequest = new JsonObjectRequest
                (Request.Method.POST, url, words, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Intent goToListAlert= new Intent(context, ListAlert.class);
                        context.startActivity(goToListAlert);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        error.printStackTrace();
                        displayAlertMessage(context.getString(R.string.error_registration_title),
                                context.getString(R.string.error_registration_server));
                    }
                });
        Volley.newRequestQueue(context).add(jsObjRequest);
    }

    public void RegistrationAPI (User user){
        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(User.class, new UserSerializer());
        gsonBuilder.setPrettyPrinting();
        Gson gson = gsonBuilder.create();

        String jsonString = gson.toJson(user);
        String url = context.getString(R.string.api_user_url);

        JSONObject jsonUser = null;

        try {
            jsonUser = new JSONObject(jsonString);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JsonObjectRequest jsObjRequest = new JsonObjectRequest
                (Request.Method.POST, url, jsonUser, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {

                        Intent goToListAlert= new Intent(context, Authentication.class);
                        context.startActivity(goToListAlert);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        displayAlertMessage(context.getString(R.string.error_registration_title),
                                context.getString(R.string.error_registration_server));
                    }
                });
        Volley.newRequestQueue(context).add(jsObjRequest);

    }

    public void displayAlertMessage(String title, String message){
        //Affiche un message d'erreur avec le titre et message passé en pramètre.
        new AlertDialog.Builder(context)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {}
                })
                .setIcon(android.R.drawable.ic_dialog_alert)
                .show();
    }

    public void updateUserPosition(LatLng lastCoordsKnown){
        String url = context.getString(R.string.api_user_update_position);
        JSONObject newPositionObject = new JSONObject();
        try {
            newPositionObject.put(context.getString(R.string.api_user_lat),lastCoordsKnown.latitude);
            newPositionObject.put(context.getString(R.string.api_user_long),lastCoordsKnown.longitude);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JsonObjectRequest jsObjRequest = new JsonObjectRequest
                (Request.Method.POST, url, newPositionObject, new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        error.printStackTrace();
                    }
                });
        Volley.newRequestQueue(context).add(jsObjRequest);
    }

    public void updateAlertOMW(String idAlert){
        String url = context.getString(R.string.api_update_omw)+idAlert;
        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                    }
                });
        Volley.newRequestQueue(context).add(stringRequest);
    }

    public void updateAlert911(String idAlert){
        String url = context.getString(R.string.api_update_911)+idAlert;
        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                    }
                });
        Volley.newRequestQueue(context).add(stringRequest);
    }

    public void updateAlertSAMU(String idAlert){
        String url = context.getString(R.string.api_update_samu)+idAlert;
        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                    }
                });
        Volley.newRequestQueue(context).add(stringRequest);
    }

    public void updateAlertBullshit(String idAlert){
        String url = context.getString(R.string.api_update_bullshit)+idAlert;
        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                    }
                });
        Volley.newRequestQueue(context).add(stringRequest);

    }

    public void updateAlertSolved(String idAlert){
        String url = context.getString(R.string.api_update_solved)+idAlert;
        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                    }
                });
        Volley.newRequestQueue(context).add(stringRequest);
    }

    public void uploadImageProfile(String imagePath) {
        String url = context.getString(R.string.api_upload_image_profile);
        HashMap<String, String> params = new HashMap<String, String>();
        File image = new File(imagePath);
        MultipartRequest multipartRequest = new MultipartRequest(url, image,
                new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                        }
                },
                new Response.Listener<String>() {
                        @Override
                        public void onResponse(String response) {
                        }
                });
        Volley.newRequestQueue(context).add(multipartRequest);
    }
}



