package com.epsi.batmapp.serializer;

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


/**
 * Created by arnaud on 21/01/16.
 */
public class AlertSerializer implements JsonSerializer<Alert>, JsonDeserializer<Alert> {

    private static String DATE ="date";
    private static String SENDER ="sender";
    private static String CRITICITY ="criticity";
    private static String TYPE ="type";
    private static String GEO ="geoPosition";
    private static String LAT ="latitude";
    private static String LNT ="lontitude";
    private static String RECEIVER ="receiver";
    private static String POLICE ="police";
    private static String SAMU ="samu";
    private static String SOLVED ="solved";


    @Override
    public JsonElement serialize(Alert alert, Type typeOfSrc, JsonSerializationContext context) {
        JsonObject jsonAlert = new JsonObject();
        jsonAlert.add(DATE, new JsonPrimitive(alert.getDate().toString()));
        jsonAlert.add(SENDER, new JsonPrimitive(alert.getSender()));
        jsonAlert.add(CRITICITY, new JsonPrimitive(alert.getCriticity()));
        jsonAlert.add(TYPE, new JsonPrimitive(alert.getType()));
        jsonAlert.add(LAT, new JsonPrimitive(alert.getCoord().latitude));
        jsonAlert.add(LNT, new JsonPrimitive(alert.getCoord().longitude));

        JsonArray receivers = new JsonArray();
        Integer[] idReceiver = alert.getReceiver();
        for(int i :  idReceiver){
            receivers.add(new JsonPrimitive(i));
        }
        jsonAlert.add(RECEIVER,receivers);
        jsonAlert.add(POLICE,new JsonPrimitive(alert.getPolice()));
        jsonAlert.add(SAMU,new JsonPrimitive(alert.getSamu()));
        jsonAlert.add(SOLVED, new JsonPrimitive(alert.isSolved()));
        return jsonAlert;
    }

    @Override
    public Alert deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        Alert alert = new Alert();
        JsonObject jsonAlert = json.getAsJsonObject();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        Date dateAlert = new Date();
        String jsonDate = jsonAlert.get(DATE).getAsString();
        try {
            dateAlert = sdf.parse(jsonDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        alert.setDate(dateAlert);

        alert.setSender(jsonAlert.get(SENDER).getAsString());
        alert.setCriticity(jsonAlert.get(CRITICITY).getAsInt());
        alert.setType(jsonAlert.get(TYPE).getAsString());

        JsonObject geo = jsonAlert.get(GEO).getAsJsonObject();
        alert.setCoord(new LatLng(geo.get(LAT).getAsDouble(),geo.get(LAT).getAsDouble()));

        JsonArray idReceivers = jsonAlert.get(RECEIVER).getAsJsonArray();
        Integer[] receivers = new Integer[idReceivers.size()];
        for(int i =0; i<idReceivers.size();i++){
            receivers[i]=idReceivers.get(i).getAsInt();
        }
        alert.setReceiver(receivers);
//        alert.setPolice(jsonAlert.get(POLICE).getAsBoolean());
//        alert.setSamu(jsonAlert.get(SAMU).getAsBoolean());
//        alert.setSolved(jsonAlert.get(SOLVED).getAsBoolean());
        return alert;
    }
}
