package com.epsi.batmapp.activity;

import android.app.Activity;
import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.ProgressBar;

import java.lang.reflect.Type;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;
import com.epsi.batmapp.R;
import com.epsi.batmapp.adapter.ListAlertAdapter;
import com.epsi.batmapp.fragment.NavigationDrawerFragment;
import com.epsi.batmapp.model.Alert;
import com.epsi.batmapp.serializer.AlertSerializer;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import java.util.ArrayList;

public class ListAlert extends AppCompatActivity implements NavigationDrawerFragment.NavigationDrawerCallbacks{

    private ArrayList<Alert> listAlerts;
    private ListView listView;
    private ListAlertAdapter adapter;

    private NavigationDrawerFragment mNavigationDrawerFragment;
    private ProgressBar pb;
    private CharSequence mTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list_alert);
        pb = (ProgressBar) findViewById(R.id.progressbar_loading);

        //On récupère le navigation drawer
        mNavigationDrawerFragment = (NavigationDrawerFragment)
                getSupportFragmentManager().findFragmentById(R.id.navigation_drawer);
        mTitle = getTitle();

        mNavigationDrawerFragment.setUp(R.id.navigation_drawer, (DrawerLayout) findViewById(R.id.drawer_layout));

        listView = (ListView) findViewById(R.id.AlertListView);

        pb.setVisibility(View.VISIBLE);

    }

    @Override
    public void onResume() {
        super.onResume();
        this.getAlerts();
    }

    public void getAlerts(){

         GsonBuilder gsonBuilder = new GsonBuilder();
         gsonBuilder.registerTypeAdapter(Alert.class, new AlertSerializer());
         gsonBuilder.setPrettyPrinting();
         final Gson gson = gsonBuilder.create();

         JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(Request.Method.GET,getString(R.string.api_listAlert_url),
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
        pb.setVisibility(View.INVISIBLE);
        adapter = new ListAlertAdapter(this, listAlerts);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Alert alertSelected = listAlerts.get(i);
                Intent goToDetailAlert = new Intent(view.getContext(), DetailAlert.class);
                goToDetailAlert.putExtra(getString(R.string.alert_selected), alertSelected);
                startActivity(goToDetailAlert);
                overridePendingTransition(R.anim.pull_in_from_left, R.anim.hold);
            }
        });
    }
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            mNavigationDrawerFragment.closeDrawer();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_list_alert, menu);
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
            case R.id.displayAlertsMap:
                Intent goToAlertsMap = new Intent(this, AlertsMap.class);
                startActivity(goToAlertsMap);
                break;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onNavigationDrawerItemSelected(int position) {
        // update the main content by replacing fragments

    }

    public void onSectionAttached(int number) {
        switch (number) {
            case 1:
                break;
            case 2:
                break;
            case 3:
                break;
        }
    }

    public static class PlaceholderFragment extends Fragment {
        /**
         * The fragment argument representing the section number for this
         * fragment.
         */
        private static final String ARG_SECTION_NUMBER = "section_number";

        /**
         * Returns a new instance of this fragment for the given section
         * number.
         */
        public static PlaceholderFragment newInstance(int sectionNumber) {
            PlaceholderFragment fragment = new PlaceholderFragment();
            Bundle args = new Bundle();
            args.putInt(ARG_SECTION_NUMBER, sectionNumber);
            fragment.setArguments(args);
            return fragment;
        }

        public PlaceholderFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            return rootView;
        }

        @Override
        public void onAttach(Activity activity) {
            super.onAttach(activity);
            ((ListAlert) activity).onSectionAttached(
                    getArguments().getInt(ARG_SECTION_NUMBER));
        }
    }



}
