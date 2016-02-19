package com.epsi.batmapp.activity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.net.Uri;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.epsi.batmapp.R;
import com.epsi.batmapp.helper.ImageDownloader;
import com.epsi.batmapp.manager.ApiManager;
import com.epsi.batmapp.model.Alert;
import com.epsi.batmapp.model.Session;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.MarkerOptions;


public class DetailAlert extends FragmentActivity implements OnMapReadyCallback {

    private Alert currentAlert;
    private TextView libelleType;
    private TextView libelleSender;
    private TextView libelleReceiver;
    private TextView libelleDistance;
    private ImageView icPolice;
    private ImageView icSamu;
    private ImageView pictureSender;

    private static final int OMW=0;
    private static final int POLICE=1;
    private static final int SAMU=2;
    private static final int WRONG_ALERT=3;
    private static final String SPACE=" ";

    private ApiManager manager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail_alert);

        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        //On récupère l'alerte séléctionnée
        currentAlert = (Alert) getIntent().getParcelableExtra(getString(R.string.alert_selected));

        //On récupère les élements de la vue
        libelleType = (TextView) findViewById(R.id.DetailTypeAlertText);
        libelleSender = (TextView) findViewById(R.id.DetailSenderText);
        libelleReceiver = (TextView) findViewById(R.id.DetailReceiverText);
        libelleDistance = (TextView) findViewById(R.id.DetailDistance);
        icPolice = (ImageView) findViewById(R.id.alertPolice);
        icSamu = (ImageView) findViewById(R.id.alertSamu);
        pictureSender = (ImageView) findViewById(R.id.DetailimageView);

        libelleType.setText(currentAlert.getType().toUpperCase());
        libelleSender.setText(currentAlert.getSender() + SPACE + getString(R.string.list_alert_sender_view));
        libelleReceiver.setText(currentAlert.getReceiver().length + SPACE + getString(R.string.list_alert_receiver_view));
        new ImageDownloader(pictureSender).execute(getString(R.string.image_server_path)+currentAlert.getPictureSender());

        if(null != currentAlert.getDistance()){
            libelleDistance.setText(currentAlert.getDistance().toString()+SPACE+getString(R.string.km));
        }

        if(!currentAlert.getPolice())
            icPolice.setVisibility(View.INVISIBLE);
        else
            icPolice.setVisibility(View.VISIBLE);

        if(!currentAlert.getSamu())
            icSamu.setVisibility(View.INVISIBLE);
        else
            icSamu.setVisibility(View.VISIBLE);

        manager = new ApiManager(this);

    }

    @Override
    public void onMapReady(GoogleMap map) {
        // On ajoute le marker de l'alert
        map.addMarker(new MarkerOptions().position(this.currentAlert.getCoord()).title(
                this.currentAlert.getSender() + SPACE + getString(R.string.marker_text)));
        map.moveCamera(CameraUpdateFactory.newLatLng(this.currentAlert.getCoord()));
        map.moveCamera(CameraUpdateFactory.zoomTo(12));
    }

    public void doActionOnAlert(View view){
        Resources res = getResources();
        final CharSequence[] items = res.getStringArray(R.array.list_action_alert);

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(getString(R.string.title_list_alert_action));
        builder.setItems(items, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int item) {
                switch (item) {
                    case OMW:
                        manager.updateAlertOMW(currentAlert.getId());
                        break;
                    case POLICE:
                        call911();
                        break;
                    case SAMU:
                        callSamu();
                        break;
                    case WRONG_ALERT:
                        manager.updateAlertBullshit(currentAlert.getId());
                        break;
                }
            }
        });
        AlertDialog alert = builder.create();
        alert.show();
    }

    public void call911(){
        if(!currentAlert.getPolice()){
            manager.updateAlert911(currentAlert.getId());
            Intent call911Intent = new Intent(Intent.ACTION_CALL, Uri.parse(getString(R.string.call_911_number)));
            startActivity(call911Intent);
        } else{
            manager.displayAlertMessage(getString(R.string.error_action_alert_title),getString(R.string.error_action_alert_911));
        }
    }

    public void callSamu(){
        if (!currentAlert.getSamu()) {
            manager.updateAlertSAMU(currentAlert.getId());
            Intent callSamuIntent = new Intent(Intent.ACTION_CALL, Uri.parse(getString(R.string.call_911_number)));
            startActivity(callSamuIntent);
        } else{
            manager.displayAlertMessage(getString(R.string.error_action_alert_title), getString(R.string.error_action_alert_samu));
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.hold, R.anim.pull_out_to_left);
    }
}
