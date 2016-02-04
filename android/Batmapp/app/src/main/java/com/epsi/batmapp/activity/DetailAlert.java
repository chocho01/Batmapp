package com.epsi.batmapp.activity;

import android.support.v4.app.FragmentActivity;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import com.epsi.batmapp.R;
import com.epsi.batmapp.model.Alert;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

public class DetailAlert extends FragmentActivity implements OnMapReadyCallback {

    private Alert currentAlert;
    private GoogleMap mMap;
    private TextView libelleType;
    private TextView libelleSender;
    private TextView libelleReceiver;
    private static final String SPACE=" ";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail_alert);
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        //On récupère l'alerte séléctionnée
        this.currentAlert = (Alert) getIntent().getParcelableExtra(getString(R.string.alert_selected));

        //On récupère les élements de la vue
        libelleType = (TextView) findViewById(R.id.DetailTypeAlertText);
        libelleSender = (TextView) findViewById(R.id.DetailSenderText);
        libelleReceiver = (TextView) findViewById(R.id.DetailReceiverText);

        libelleType.setText(currentAlert.getType().toUpperCase());
        libelleSender.setText(currentAlert.getSender() +SPACE+ getString(R.string.list_alert_sender_view));
        libelleReceiver.setText(currentAlert.getReceiver().length + SPACE + getString(R.string.list_alert_receiver_view));

    }

    @Override
    public void onMapReady(GoogleMap map) {
        // On ajoute le marker de l'alert
        map.addMarker(new MarkerOptions().position(this.currentAlert.getCoord()).title("Help"));
        map.moveCamera(CameraUpdateFactory.newLatLng(this.currentAlert.getCoord()));
        map.moveCamera(CameraUpdateFactory.zoomTo(10));
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.hold, R.anim.pull_out_to_left);
    }
}
