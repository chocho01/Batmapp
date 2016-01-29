package com.epsi.batmapp.activity;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import java.lang.reflect.Type;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;
import com.epsi.batmapp.R;
import com.epsi.batmapp.adapter.ListAlertAdapter;
import com.epsi.batmapp.model.Alert;
import com.epsi.batmapp.serializer.AlertSerializer;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;

public class ListAlert extends AppCompatActivity {

    ArrayList<Alert> listAlerts;
    ListView listView;
    ListAlertAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list_alert);

        listView = (ListView) findViewById(R.id.AlertListView);
        getAlerts();

    }
     public void getAlerts(){

         GsonBuilder gsonBuilder = new GsonBuilder();
         gsonBuilder.registerTypeAdapter(Alert.class, new AlertSerializer());
         gsonBuilder.setPrettyPrinting();
         final Gson gson = gsonBuilder.create();

         JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(Request.Method.GET,getString(R.string.api_listAlert_url),
                 new Response.Listener<JSONArray>(){
                     @Override
                     public void onResponse(JSONArray response) {
                         Type listType = new TypeToken<ArrayList<Alert>>(){ }.getType();
                         listAlerts = gson.fromJson(response.toString(),listType);
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
        adapter = new ListAlertAdapter(this, listAlerts);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Alert alertSelected = listAlerts.get(i);
                Intent goToDetailAlert = new Intent(view.getContext(), DetailAlert.class);
                goToDetailAlert.putExtra(getString(R.string.alert_selected), alertSelected);
                startActivity(goToDetailAlert);
                overridePendingTransition(R.anim.pull_in_from_left, R.anim.hold);
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_create_alert, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        switch (item.getItemId()) {
            case R.id.createAlert:
                Intent goToCreateAlert = new Intent(this, CreateAlert.class);
                startActivity(goToCreateAlert);
                break;
        }

        return super.onOptionsItemSelected(item);
    }

}
