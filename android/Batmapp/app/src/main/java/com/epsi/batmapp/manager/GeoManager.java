package com.epsi.batmapp.manager;

import android.Manifest;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;

import com.epsi.batmapp.R;
import com.google.android.gms.maps.model.LatLng;

/**
 * Created by arnaud on 12/02/16.
 */
public class GeoManager {

    private static GeoManager instance;
    private Context context;

    private ApiManager mApiManager;
    private LocationManager mLocationManager;
    private SharedPreferences mSharedManager;
    private LatLng lastCoordsKnown;

    private static final String EMPTY="";
    private static final Long MINUTE = Long.valueOf(1);
    private static final Long LOCATION_REFRESH_TIME = 1000 * 60 * MINUTE;
    private static final Float LOCATION_REFRESH_DISTANCE = 10f;

    public static GeoManager getInstance(Context context) {
        if (instance == null) {
            instance = new GeoManager(context);
        }
        return instance;
    }

    private GeoManager(Context context) {
        this.context = context;
        this.mApiManager = new ApiManager(context);
        this.mSharedManager = context.getSharedPreferences (context.getString(R.string.last_coord_pref), Context.MODE_PRIVATE);
        this.initiateLocationManager();
    }

    public LatLng getLastCoordsKnownFromPreferences() {

        String lat = mSharedManager.getString(context.getString(R.string.last_coord_lat),EMPTY);
        String lon = mSharedManager.getString(context.getString(R.string.last_coord_lon),EMPTY);

        LatLng coordonates = new LatLng(Double.parseDouble(lat),Double.parseDouble(lon));
        return coordonates;
    }

    public void initiateLocationManager(){
        mLocationManager = (LocationManager) context.getSystemService(context.LOCATION_SERVICE);
        if ( !mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER ) ) {
            mApiManager.displayAlertMessage(context.getString(R.string.alert_gps_disabled_title), context.getString(R.string.alert_gps_disabled_message));
        }else{
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                    && ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                return;
            }
            mLocationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, LOCATION_REFRESH_TIME,
                    LOCATION_REFRESH_DISTANCE, mLocationListener);
            Location lastLocation = mLocationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);

            if(lastLocation != null){
                lastCoordsKnown = new LatLng(lastLocation.getLatitude(),lastLocation.getLongitude());
            }
        }
    }

    private final LocationListener mLocationListener = new LocationListener() {
        @Override
        public void onLocationChanged(final Location location) {
            lastCoordsKnown = new LatLng(location.getLatitude(),location.getLongitude());

            //On envoi notre dernière postion au serveur
            mApiManager.updateUserPosition(lastCoordsKnown);

            //On enregistre la dernière position dans les préfèrences
            SharedPreferences.Editor editor = mSharedManager.edit();
            editor.clear();
            editor.putString(context.getString(R.string.last_coord_lat), String.valueOf(lastCoordsKnown.latitude));
            editor.putString(context.getString(R.string.last_coord_lon), String.valueOf(lastCoordsKnown.longitude));
            editor.commit();
        }

        @Override
        public void onStatusChanged(String s, int i, Bundle bundle) {
        }

        @Override
        public void onProviderEnabled(String s) {
        }

        @Override
        public void onProviderDisabled(String s) {
        }
    };
}
