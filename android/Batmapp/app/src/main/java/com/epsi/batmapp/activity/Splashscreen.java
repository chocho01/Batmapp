package com.epsi.batmapp.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Handler;
import android.os.Bundle;

import com.epsi.batmapp.R;
import com.epsi.batmapp.manager.GeoManager;

public class Splashscreen extends Activity {

    private final int SPLASH_DISPLAY_LENGTH = 2000;

    @Override
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.activity_splashscreen);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                /* Create an Intent that will start the Menu-Activity. */
                Intent goToAuthentication = new Intent(Splashscreen.this, Authentication.class);
                Splashscreen.this.startActivity(goToAuthentication);
                Splashscreen.this.finish();
            }
        }, SPLASH_DISPLAY_LENGTH);

        //On instancie le singleton GeoManager pour la géolocalisation de l'utilisateur
        GeoManager.getInstance(this);

    }
}