package com.epsi.batmapp.activity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.drawable.ColorDrawable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.epsi.batmapp.R;
import com.epsi.batmapp.model.Session;
import com.epsi.batmapp.model.User;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.CookieHandler;
import java.net.CookieManager;

public class Authentication extends AppCompatActivity {

    private EditText loginText;
    private EditText pwdText;
    private User userConnected;
    private SharedPreferences userDetails;
    private ProgressBar pb;
    public static final String EMPTY="";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_authentication);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.green_lite_1)));
        pb = (ProgressBar) findViewById(R.id.progressBar);
        pb.setVisibility(View.INVISIBLE);

        loginText = (EditText) findViewById(R.id.loginText);
        pwdText = (EditText) findViewById(R.id.passwordText);

        //On récupère l'email si l'utilisateur c'est déjà connecté
        String emailSession="";
        userDetails = this.getSharedPreferences
                (getString(R.string.detail_user_session), Context.MODE_PRIVATE);

        emailSession = userDetails.getString(getString(R.string.email_detail_user), EMPTY);
        loginText.setText(emailSession);

        Button loginButton = (Button) findViewById(R.id.buttonLogin);
        Button registerButton = (Button) findViewById(R.id.buttonRegister);

        //On défini le listener pour les boutons
        View.OnClickListener clickListener =  new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                switch(view.getId()){
                    case R.id.buttonLogin:
                        launchAuthentication();
                        break;
                    case R.id.buttonRegister:
                        launchRegistration();
                        break;
                }
            }
        };
        loginButton.setOnClickListener(clickListener);
        registerButton.setOnClickListener(clickListener);
    }

  public void launchAuthentication(){
      //Fonction appel quand on valide l'authentication
      String email = loginText.getText().toString();
      String pwd= pwdText.getText().toString();

      //On vérifie que tous les champs sont rentrés
      if(email.equals(EMPTY) || pwd.equals(EMPTY)) {
          displayAlertMessage(getString(R.string.error_authentication_title),
                  getString(R.string.error_authentication_champs));
      }else {

          //On récupère les identifiants saisis par l'utilisateur
          JSONObject jsonParams = new JSONObject();
          try {
              jsonParams.put(getString(R.string.api_login_param_user),email);
              jsonParams.put(getString(R.string.api_login_param_pwd),pwd);
          } catch (JSONException e) {
              e.printStackTrace();
          }

          //On appel le web service d'authentification
          String url = getString(R.string.api_login_url);
          pb.setVisibility(View.VISIBLE);
          JsonObjectRequest jsObjRequest = new JsonObjectRequest
                  (Request.Method.POST, url, jsonParams, new Response.Listener<JSONObject>() {

                      @Override
                      public void onResponse(JSONObject response) {
                          try {
                              userConnected = new User();
                              userConnected.setId(response.getString("_id"));
                              userConnected.setEmail(response.getString("email"));
                              userConnected.setFirstName(response.getString("firstName"));
                              userConnected.setLastName(response.getString("lastName"));
                              userConnected.setPicture(response.getString("profilPicture"));

                              Session.getInstance(userConnected);

                              SharedPreferences.Editor editor = userDetails.edit();
                              editor.clear();
                              editor.putString(getString(R.string.email_detail_user), userConnected.getEmail());
                              editor.putString(getString(R.string.f_name_user_session), userConnected.getFirstName());
                              editor.putString(getString(R.string.l_name_user_session), userConnected.getLastName());
                              editor.putString(getString(R.string.picture_user_session),userConnected.getPicture());
                              editor.commit();

                              pb.setVisibility(View.INVISIBLE);
                              Intent goToListAlert= new Intent(Authentication.this, ListAlert.class);
                              startActivity(goToListAlert);

                          } catch (JSONException e) {
                              e.printStackTrace();
                              pb.setVisibility(View.INVISIBLE);
                          }
                      }
                  }, new Response.ErrorListener() {
                      @Override
                      public void onErrorResponse(VolleyError error) {
                          pb.setVisibility(View.INVISIBLE);
                          displayAlertMessage(getString(R.string.error_authentication_title),
                                  getString(R.string.error_authentication_401));
                      }
                  });
          /*
           *On définis le cookie manager pour gérer la session coté serveur
           * car Android Volley ne le gère pas
           */

          CookieManager manager = new CookieManager();
          CookieHandler.setDefault(manager);
          Volley.newRequestQueue(this).add(jsObjRequest);
      }
  }

    public void launchRegistration(){
        /*
         *Fonction appellé au clique sur le bouton s'enregistrer
         *Renvoi sur l'écran d'inscription
         */
        Intent goToRegistration = new Intent(this, Registration.class);
        this.startActivity(goToRegistration);
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
