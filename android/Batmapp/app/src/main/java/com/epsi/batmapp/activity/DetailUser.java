package com.epsi.batmapp.activity;

import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;
import com.epsi.batmapp.R;
import com.epsi.batmapp.adapter.ListAlertAdapter;
import com.epsi.batmapp.adapter.ListAlertPersoAdapter;
import com.epsi.batmapp.fragment.NavigationDrawerFragment;
import com.epsi.batmapp.helper.ImageDownloader;
import com.epsi.batmapp.manager.ApiManager;
import com.epsi.batmapp.model.Alert;
import com.epsi.batmapp.model.Session;
import com.epsi.batmapp.serializer.AlertSerializer;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

public class DetailUser extends AppCompatActivity implements NavigationDrawerFragment.NavigationDrawerCallbacks{

    private static final int SELECTED_PICTURE = 1;

    private String selectedImagePath;
    private ImageView img;
    private ListView alertsListView;
    private ArrayList<Alert> listAlerts;
    private ListAlertPersoAdapter adapter;
    private TextView nameText;
    private TextView emailText;

    private Session session;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail_user);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.green_lite_1)));

        //On récupère la session utilisateur et les différents élément de la vue
        session = Session.getInstance(null);
        img = (ImageView) findViewById(R.id.imageViewDetailUser);
        nameText = (TextView) findViewById(R.id.DetailUserName);
        emailText = (TextView) findViewById(R.id.DetailUserEmail);

        //On télécharge l'image de profile de l'utilisateur
        new ImageDownloader(img).execute(getString(R.string.image_server_path)
                +session.getUserConnected().getPicture());

        nameText.setText(session.getUserConnected().getFirstName() + " " + session.getUserConnected().getLastName());
        emailText.setText(session.getUserConnected().getEmail());

        alertsListView = (ListView) findViewById(R.id.AlertDetailUserListView);

    }

    @Override
    protected void onResume() {
        //On rafraichit la liste des alertes à chaque fois qu'on revient sur l'activité
        super.onResume();
        this.getAlerts();
    }

    public void openGallery(View view){
        //Fonction pour ouvrir le gestionnaire d'image
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Select file to upload "), SELECTED_PICTURE);
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
    /*
        Fonction de callback du gestionnaire d'image
        On récupère l'image choisi et on l'envoi au serveur
     */
        if (resultCode == RESULT_OK) {
            if (requestCode == SELECTED_PICTURE) {
                Uri selectedImageUri = data.getData();
                selectedImagePath = getPath(selectedImageUri);
                ApiManager manager = new ApiManager(this);
                manager.uploadImageProfile(selectedImagePath);
            }
        }
    }

    public String getPath(Uri uri){
        //Fonction pour récupèrer le chemin d'une image sur le téléphone
        String[] projection = { MediaStore.Images.Media.DATA };
        Cursor cursor = managedQuery(uri, projection, null, null, null);
        if (cursor == null) return null;
        int column_index =cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToFirst();
        String s=cursor.getString(column_index);
        cursor.close();
        return s;
    }

    public void getAlerts(){
        //Appel web service pour récupèrer la liste des alertes perso
        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(Alert.class, new AlertSerializer());
        gsonBuilder.setPrettyPrinting();
        final Gson gson = gsonBuilder.create();

        String url = getString(R.string.api_listAlertPerso_url) + session.getUserConnected().getId();

        JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(Request.Method.GET,url,
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
        //Callback succès, affiche les alertes récupèrées du serveur
        adapter = new ListAlertPersoAdapter(this, listAlerts);
        alertsListView.setAdapter(adapter);

        alertsListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

            }
        });
    }

    @Override
    public void onNavigationDrawerItemSelected(int position) {

    }
}
