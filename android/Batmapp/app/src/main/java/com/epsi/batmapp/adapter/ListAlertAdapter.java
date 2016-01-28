package com.epsi.batmapp.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.epsi.batmapp.R;
import com.epsi.batmapp.model.Alert;

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


        View rowView = inflater.inflate( R.layout.row_alert_list, parent, false);

        TextView typeText = (TextView) rowView.findViewById(R.id.TypeAlertText);
        TextView senderText = (TextView) rowView.findViewById(R.id.SenderText);
        TextView receiverText = (TextView) rowView.findViewById(R.id.ReceiverText);

        typeText.setText(itemsArrayList.get(position).getType().toUpperCase());
        senderText.setText(itemsArrayList.get(position).getSender() +SPACE+ context.getString(R.string.list_alert_sender_view));
        receiverText.setText(itemsArrayList.get(position).getReceiver().length +SPACE+ context.getString(R.string.list_alert_receiver_view));

        return rowView;
    }
}
