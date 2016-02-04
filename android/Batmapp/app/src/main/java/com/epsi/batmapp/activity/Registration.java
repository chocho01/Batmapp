package com.epsi.batmapp.activity;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.EditText;
import android.widget.ProgressBar;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.epsi.batmapp.R;
import com.epsi.batmapp.model.User;
import com.epsi.batmapp.serializer.UserSerializer;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by arnaud on 20/01/16.
 */
public class Registration extends AppCompatActivity {

    EditText emailText;
    EditText pwdText;
    EditText fNameText;
    EditText lNameText;

    ProgressBar pb;

    JSONObject jsonUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registration);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.bat_green)));

        emailText = (EditText) findViewById(R.id.emailText);
        pwdText = (EditText) findViewById(R.id.pwdRegistrationText);
        fNameText = (EditText) findViewById(R.id.firstNameText);
        lNameText = (EditText) findViewById(R.id.lastNameText);

        pb = (ProgressBar) findViewById(R.id.progressBar2);
        pb.setVisibility(View.INVISIBLE);

    }

    public void sendRegistration(View view) {

        pb.setVisibility(View.VISIBLE);

        String email ="";
        String pwd ="";
        String fName ="";
        String lName ="";

        email=emailText.getText().toString();
        pwd = pwdText.getText().toString();
        fName=fNameText.getText().toString();
        lName=lNameText.getText().toString();

        if(email.equals("")||pwd.equals("")||fName.equals("")||lName.equals("")){
            displayAlertMessage(getString(R.string.error_registration_title),
                    getString(R.string.error_authentication_champs));
        }else{
            User user = new User();
            user.setEmail(email);
            user.setPassword(pwd);
            user.setFirstName(fName);
            user.setLastName(lName);

            GsonBuilder gsonBuilder = new GsonBuilder();
            gsonBuilder.registerTypeAdapter(User.class, new UserSerializer());
            gsonBuilder.setPrettyPrinting();
            Gson gson = gsonBuilder.create();

            String jsonString = gson.toJson(user);
            String url = getString(R.string.api_user_url);

            try {
                 jsonUser = new JSONObject(jsonString);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            JsonObjectRequest jsObjRequest = new JsonObjectRequest
                    (Request.Method.POST, url, jsonUser, new Response.Listener<JSONObject>() {

                        @Override
                        public void onResponse(JSONObject response) {
                            pb.setVisibility(View.INVISIBLE);
                            Intent goToListAlert= new Intent(Registration.this, Authentication.class);
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
