package com.epsi.batmapp.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.epsi.batmapp.R;
import com.epsi.batmapp.model.Alert;

import java.text.DecimalFormat;
import java.util.ArrayList;

/**
 * Created by arnaud on 22/01/16.
 */
public class ListAlertAdapter extends ArrayAdapter<Alert> {

    private final Context context;
    private final ArrayList<Alert> itemsArrayList;
    private static final String SPACE=" ";

    public ListAlertAdapter(Context context, ArrayList<Alert> itemsArrayList) {

        super(context, R.layout.row_alert_list, itemsArrayList);

        this.context = context;
        this.itemsArrayList = itemsArrayList;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        DecimalFormat f = new DecimalFormat();
        f.setMaximumFractionDigits(0);

        View rowView = inflater.inflate( R.layout.row_alert_list, parent, false);

        TextView typeText = (TextView) rowView.findViewById(R.id.TypeAlertText);
        TextView senderText = (TextView) rowView.findViewById(R.id.SenderText);
        TextView receiverText = (TextView) rowView.findViewById(R.id.ReceiverText);
        TextView distanceText = (TextView) rowView.findViewById(R.id.distanceText);
        ImageView policeView = (ImageView) rowView.findViewById(R.id.alertPoliceIc);
        ImageView samuView = (ImageView) rowView.findViewById(R.id.alertSamuIc);

        typeText.setText(itemsArrayList.get(position).getType().toUpperCase());
        senderText.setText(itemsArrayList.get(position).getSender() +SPACE+ context.getString(R.string.list_alert_sender_view));
        receiverText.setText(itemsArrayList.get(position).getReceiver().length +SPACE+ context.getString(R.string.list_alert_receiver_view));
        if(itemsArrayList.get(position).getDistance()!= null){
            distanceText.setText(f.format(itemsArrayList.get(position).getDistance())+SPACE+context.getString(R.string.km));
        }

        if(!itemsArrayList.get(position).getPolice()){
            policeView.setVisibility(View.INVISIBLE);
        }

        if(!itemsArrayList.get(position).getSamu()){
            samuView.setVisibility(View.INVISIBLE);
        }


//        switch (itemsArrayList.get(position).getCriticity()){
//            case 1:
//                typeText.setTextColor(Color.GREEN);
//                break;
//            case 2:
//                typeText.setTextColor(Color.YELLOW);
//                break;
//            case 3:
//                typeText.setTextColor(Color.RED);
//                break;
//        }

        return rowView;
    }
}
