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

import com.epsi.batmapp.R;
import com.epsi.batmapp.manager.ApiManager;
import com.epsi.batmapp.model.User;


/**
 * Created by arnaud on 20/01/16.
 */
public class Registration extends AppCompatActivity {

    EditText emailText;
    EditText pwdText;
    EditText fNameText;
    EditText lNameText;

    ProgressBar pb;

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

        String email = emailText.getText().toString();
        String pwd = pwd = pwdText.getText().toString();
        String fName = fNameText.getText().toString();
        String lName =lNameText.getText().toString();

        ApiManager manager = new ApiManager(this);

        if(email.equals("")||pwd.equals("")||fName.equals("")||lName.equals("")){
            manager.displayAlertMessage(getString(R.string.error_registration_title),
                    getString(R.string.error_authentication_champs));
        }else{
            User user = new User();
            user.setEmail(email);
            user.setPassword(pwd);
            user.setFirstName(fName);
            user.setLastName(lName);
            //user.setLastCoordKnown();
            manager.RegistrationAPI(user);
        }
    }
}
