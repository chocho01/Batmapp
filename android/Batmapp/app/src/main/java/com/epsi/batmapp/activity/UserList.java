package com.epsi.batmapp.activity;

import android.graphics.drawable.ColorDrawable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.widget.ListView;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;
import com.epsi.batmapp.R;
import com.epsi.batmapp.adapter.ListUserAdapter;
import com.epsi.batmapp.model.User;
import com.epsi.batmapp.serializer.UserSerializer;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;

import java.lang.reflect.Type;
import java.util.ArrayList;

public class UserList extends AppCompatActivity {

    private ArrayList<User> listUser;
    private ListView listView;
    private ListUserAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_list);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.green_lite_1)));
        listView = (ListView) findViewById(R.id.UserListView);
    }

    @Override
    protected void onResume() {
        super.onResume();
        this.getUsers();
    }

    public void getUsers(){
        //Récupère la liste des utilisateurs de l'application
        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(User.class, new UserSerializer());
        gsonBuilder.setPrettyPrinting();
        final Gson gson = gsonBuilder.create();

        JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(Request.Method.GET,getString(R.string.api_listUsers_url),
                new Response.Listener<JSONArray>(){
                    @Override
                    public void onResponse(JSONArray response) {
                        Type listType = new TypeToken<ArrayList<User>>(){ }.getType();
                        listUser = gson.fromJson(response.toString(),listType);
                        displayData();
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                    }
                });
        Volley.newRequestQueue(this).add(jsonArrayRequest);
    }

    public void displayData(){
        //Afiiche les données récupèré du serveur
        adapter = new ListUserAdapter(this,listUser);
        listView.setAdapter(adapter);
    }
}
