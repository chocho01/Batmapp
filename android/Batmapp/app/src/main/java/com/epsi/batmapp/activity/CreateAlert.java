package com.epsi.batmapp.activity;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.NumberPicker;
import android.widget.ProgressBar;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.epsi.batmapp.R;
import com.epsi.batmapp.model.Alert;
import com.epsi.batmapp.serializer.AlertSerializer;
import com.google.android.gms.maps.model.LatLng;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

public class CreateAlert extends AppCompatActivity {

    private LocationManager mLocationManager;
    private static final Long MINUTE = Long.valueOf(1);
    private static final Long LOCATION_REFRESH_TIME = 1000 * 60 * MINUTE;
    private static final Float LOCATION_REFRESH_DISTANCE = 10f;

    private ArrayList<String> lst;
    private Alert newAlert;
    private boolean easterEgg;

    private NumberPicker picker;
    private Spinner spinner;
    private ProgressBar pb;

    private SharedPreferences userDetails;
    public static final String EMPTY="";
    public static final String SPACE=" ";

    private JSONObject jsonAlert;
    private int selectedCriticity = 1;

    private final LocationListener mLocationListener = new LocationListener() {
        @Override
        public void onLocationChanged(final Location location) {
            //On met à jour les coordonnées de l'alert si elles changent
            LatLng coords = new LatLng(location.getLatitude(),location.getLongitude());
            newAlert.setCoord(coords);
            pb.setVisibility(View.INVISIBLE);
            Toast.makeText( getBaseContext(), getString(R.string.maj_coords), Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onStatusChanged(String s, int i, Bundle bundle) {
            System.out.println("onStatusChanged");
        }

        @Override
        public void onProviderEnabled(String s) {
            System.out.println("onProviderEnabled");

        }

        @Override
        public void onProviderDisabled(String s) {
            System.out.println("onProviderDisabled");

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_alert);

        pb = (ProgressBar) findViewById(R.id.progressBarCreateAlert);
        pb.setVisibility(View.INVISIBLE);

        newAlert = new Alert();

        userDetails =  this.getSharedPreferences(getString(R.string.detail_user_session), Context.MODE_PRIVATE);
        String sender = userDetails.getString(getString(R.string.f_name_user_session),EMPTY);
        sender +=  SPACE + userDetails.getString(getString(R.string.l_name_user_session),EMPTY);

        newAlert.setSender(sender);
        this.initiateLocationManager();

        spinner = (Spinner) findViewById(R.id.spinner_type);

        Resources res = getResources();
        String[] listType = res.getStringArray(R.array.type_array);
        lst = new ArrayList<String>(Arrays.asList(listType));
        ArrayAdapter<String> adapter  = new ArrayAdapter<String>(this,android.R.layout.simple_list_item_1, lst);

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        //Easter egg
        TextView view = (TextView) findViewById(R.id.libelleSelectType);
        view.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                if(easterEgg){
                    Toast.makeText(v.getContext(),R.string.easteregg_ever_activated,Toast.LENGTH_SHORT).show();

                }else{
                    lst.add(getString(R.string.apero));
                    Toast.makeText(v.getContext(),R.string.easteregg_activated,Toast.LENGTH_SHORT).show();
                    easterEgg = true;
                }
                return true;
            }
        });

        picker = (NumberPicker) findViewById(R.id.numberPicker);
        picker.setMinValue(1);
        picker.setMaxValue(5);
        picker.setOnValueChangedListener(new NumberPicker.OnValueChangeListener() {
            @Override
            public void onValueChange(NumberPicker numberPicker, int oldVal, int newVal) {
               selectedCriticity = newVal;
            }
        });

    }

    public void initiateLocationManager(){
        mLocationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        if ( !mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER ) ) {
            displayAlertMessage(getString(R.string.alert_gps_disabled_title),getString(R.string.alert_gps_disabled_message));
        }else{
            pb.setVisibility(View.VISIBLE);
            Toast.makeText(this,getString(R.string.recup_coord),Toast.LENGTH_LONG).show();
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                    && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                return;
            }

            mLocationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, LOCATION_REFRESH_TIME,
                    LOCATION_REFRESH_DISTANCE, mLocationListener);
        }
    }

    public void sendAlert(View view){
        pb.setVisibility(View.VISIBLE);
        newAlert.setDate(new Date());
        newAlert.setCriticity(selectedCriticity);
        newAlert.setType(spinner.getSelectedItem().toString());

        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(Alert.class, new AlertSerializer());
        gsonBuilder.setPrettyPrinting();
        Gson gson = gsonBuilder.create();

        String jsonString = gson.toJson(newAlert);
        String url = getString(R.string.api_create_alert_url);

        try {
            jsonAlert = new JSONObject(jsonString);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JsonObjectRequest jsObjRequest = new JsonObjectRequest
                (Request.Method.POST, url, jsonAlert, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        pb.setVisibility(View.INVISIBLE);
                        Intent goToListAlert= new Intent(CreateAlert.this, ListAlert.class);
                        startActivity(goToListAlert);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        pb.setVisibility(View.INVISIBLE);
                        displayAlertMessage(getString(R.string.error_registration_title),
                                getString(R.string.error_registration_server));
                    }
                });
        Volley.newRequestQueue(this).add(jsObjRequest);
    }

    public void displayAlertMessage(String title, String message){
        //Affiche un message d'erreur avec le titre et message passé en pramètre.
        new AlertDialog.Builder(this)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {}
                })
                .setIcon(android.R.drawable.ic_dialog_alert)
                .show();
    }
}
