package com.epsi.batmapp.adapter;

/**
 * Created by arnaud on 18/02/16.
 */

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.epsi.batmapp.R;
import com.epsi.batmapp.manager.ApiManager;
import com.epsi.batmapp.model.Alert;

import java.util.ArrayList;



/**
 * Created by arnaud on 22/01/16.
 */
public class ListAlertPersoAdapter extends ArrayAdapter<Alert> {

    private final Context context;
    private final ArrayList<Alert> itemsArrayList;
    private static final String SPACE=" ";
    private ImageButton checkButton;

    public ListAlertPersoAdapter(Context context, ArrayList<Alert> itemsArrayList) {

        super(context, R.layout.row_alert_list, itemsArrayList);

        this.context = context;
        this.itemsArrayList = itemsArrayList;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View rowView = inflater.inflate( R.layout.row_detail_user_alert_list, parent, false);

        TextView typeText = (TextView) rowView.findViewById(R.id.TypeAlertText);
        TextView receiverText = (TextView) rowView.findViewById(R.id.ReceiverText);
        ImageView policeView = (ImageView) rowView.findViewById(R.id.alertPoliceIc);
        ImageView samuView = (ImageView) rowView.findViewById(R.id.alertSamuIc);

        checkButton = (ImageButton) rowView.findViewById(R.id.checkButton);
        if(!itemsArrayList.get(position).isSolved()){
            checkButton.setColorFilter(Color.GRAY);

        } else {
            checkButton.setColorFilter(Color.rgb(0,150,136));
        }

        typeText.setText(itemsArrayList.get(position).getType().toUpperCase());
        receiverText.setText(itemsArrayList.get(position).getReceiver().length +SPACE+ context.getString(R.string.list_alert_receiver_view));

        if(!itemsArrayList.get(position).getPolice()){
            policeView.setVisibility(View.INVISIBLE);
        }

        if(!itemsArrayList.get(position).getSamu()){
            samuView.setVisibility(View.INVISIBLE);
        }

        //Permet de supprimer une alert qu'on à créée
        checkButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if(!itemsArrayList.get(position).isSolved()){
                    ApiManager manager = new ApiManager(view.getContext());
                    manager.updateAlertSolved(itemsArrayList.get(position).getId());
                    ImageButton button = (ImageButton) view.findViewById(view.getId());
                    button.setColorFilter(Color.rgb(0,150,136));
                }
            }
        });

        return rowView;
    }

}
