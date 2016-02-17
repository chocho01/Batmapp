package com.epsi.batmapp.serializer;

import com.epsi.batmapp.helper.ImageDownloader;
import com.epsi.batmapp.model.Alert;
import com.google.android.gms.maps.model.LatLng;
import com.google.gson.JsonArray;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.ExecutionException;


/**
 * Created by arnaud on 21/01/16.
 */
public class AlertSerializer implements JsonSerializer<Alert>, JsonDeserializer<Alert> {

    private static String ID = "_id";
    private static String DATE ="date";
    private static String SENDER ="sender";
    private static String NAME ="name";
    private static String CRITICITY ="criticity";
    private static String DISTANCE = "distance";
    private static String TYPE ="type";
    private static String GEO ="geoPosition";
    private static String LAT ="latitude";
    private static String LNT ="longitude";
    private static String RECEIVER ="receiver";
    private static String POLICE ="police";
    private static String SAMU ="samu";
    private static String SOLVED ="solved";
    private static String PICTURE = "profilPicture";

    @Override
    public JsonElement serialize(Alert alert, Type typeOfSrc, JsonSerializationContext context) {
        JsonObject jsonAlert = new JsonObject();
        jsonAlert.add(SENDER, new JsonPrimitive(alert.getSender()));
        jsonAlert.add(CRITICITY, new JsonPrimitive(alert.getCriticity()));
        jsonAlert.add(TYPE, new JsonPrimitive(alert.getType()));
        jsonAlert.add(LAT, new JsonPrimitive(alert.getCoord().latitude));
        jsonAlert.add(LNT, new JsonPrimitive(alert.getCoord().longitude));

        return jsonAlert;
    }

    @Override
    public Alert deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        Alert alert = new Alert();
        JsonObject jsonAlert = json.getAsJsonObject();

        alert.setId(jsonAlert.get(ID).getAsString());

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        Date dateAlert = new Date();
        String jsonDate = jsonAlert.get(DATE).getAsString();
        try {
            dateAlert = sdf.parse(jsonDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        alert.setDate(dateAlert);

        if(jsonAlert.get(SENDER) instanceof JsonObject){
            alert.setSender(jsonAlert.get(SENDER).getAsJsonObject().get(NAME).getAsString());
            alert.setPictureSender(jsonAlert.get(SENDER).getAsJsonObject().get(PICTURE).getAsString());
        }else {
            alert.setSender(jsonAlert.get(SENDER).getAsString());
        }

        alert.setCriticity(jsonAlert.get(CRITICITY).getAsInt());
        alert.setType(jsonAlert.get(TYPE).getAsString());

        if(null != jsonAlert.get(DISTANCE)){
            alert.setDistance(jsonAlert.get(DISTANCE).getAsDouble()/1000);
        }

        JsonObject geo = jsonAlert.get(GEO).getAsJsonObject();
        alert.setCoord(new LatLng(geo.get(LAT).getAsDouble(),geo.get(LNT).getAsDouble()));

        JsonArray idReceivers = jsonAlert.get(RECEIVER).getAsJsonArray();
        String[] receivers = new String[idReceivers.size()];
        for(int i =0; i<idReceivers.size();i++){
            receivers[i]=idReceivers.get(i).getAsString();
        }
        alert.setReceiver(receivers);

        if(null != jsonAlert.get(POLICE))
            alert.setPolice(jsonAlert.get(POLICE).getAsBoolean());
        else
            alert.setPolice(false);

        if(null != jsonAlert.get(SAMU))
            alert.setSamu(jsonAlert.get(SAMU).getAsBoolean());
        else
            alert.setSamu(false);

        if(null != jsonAlert.get(SOLVED))
            alert.setSolved(jsonAlert.get(SOLVED).getAsBoolean());
        else
            alert.setSolved(false);

        return alert;
    }
}
