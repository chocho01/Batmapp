package com.epsi.batmapp.activity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.drawable.ColorDrawable;
import android.speech.RecognizerIntent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.NumberPicker;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.epsi.batmapp.R;
import com.epsi.batmapp.manager.ApiManager;
import com.epsi.batmapp.manager.GeoManager;
import com.epsi.batmapp.model.Alert;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

public class CreateAlert extends AppCompatActivity {

    private ArrayList<String> lst;
    private Alert newAlert;
    private boolean easterEgg;

    private NumberPicker picker;
    private Spinner spinner;
    private SharedPreferences userDetails;

    private int selectedCriticity = 1;
    private String sender;
    private ApiManager manager;

    private static final String EMPTY="";
    private static final String SPACE=" ";
    protected static final int REQUEST_OK = 1;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_alert);

        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.green_lite_1)));

        //On instancie l'API manager et une nouvelle alerte
        manager =  new ApiManager(this);
        userDetails =  this.getSharedPreferences(getString(R.string.detail_user_session), Context.MODE_PRIVATE);
        sender = userDetails.getString(getString(R.string.f_name_user_session), EMPTY);
        sender +=  SPACE + userDetails.getString(getString(R.string.l_name_user_session),EMPTY);

        newAlert = new Alert();
        newAlert.setSender(sender);

        //On récupère les éléments de la vue, on peuple le spinner...

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

        //On récupère le picker pour la criticité et fixe les valeurs entre 1 et 5
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

    public void sendAlert(View view){
        //Set les différents attribu d'une alerte et l'envoie au serveur
        newAlert.setDate(new Date());
        newAlert.setCoord(GeoManager.getInstance(this).getLastCoordsKnownFromPreferences());
        newAlert.setCriticity(selectedCriticity);
        newAlert.setType(spinner.getSelectedItem().toString());

        if(newAlert.getCoord()!= null){
            manager.createAlertAPI(newAlert);
        }else{
            displayAlertMessage(getString(R.string.error_coords_title),getString(R.string.error_coords));
        }
    }

    public void displayAlertMessage(String title, String message){
        //Affiche un message d'erreur avec le titre et message passé en pramètre.
        new AlertDialog.Builder(this)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                    }
                })
                .setIcon(android.R.drawable.ic_dialog_alert)
                .show();
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
            case R.id.speech_recorder_button:
                launchSpeechRecognition();
        }

        return super.onOptionsItemSelected(item);
    }

    public void launchSpeechRecognition(){
        //Ouvre la fenetre de dialogue pour la reconaissance vocal
        Intent i = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        i.putExtra(RecognizerIntent.EXTRA_LANGUAGE, "fr-FR");
        try {
            startActivityForResult(i,REQUEST_OK);
        } catch (Exception e) {
            Toast.makeText(this, getString(R.string.alert_vocal_receiver_error), Toast.LENGTH_LONG).show();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        /*
            Fonction de callback de succès pour la reconaissance vocal
            Envoie une alerte automatique au serveur
         */
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode==REQUEST_OK  && resultCode==RESULT_OK) {
            ArrayList<String> thingsYouSaid = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
            manager.createVocalAlertAPI(thingsYouSaid);
        }
    }
}
