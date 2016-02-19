package com.epsi.batmapp.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.epsi.batmapp.R;
import com.epsi.batmapp.helper.ImageDownloader;
import com.epsi.batmapp.model.Alert;
import com.epsi.batmapp.model.User;

import java.text.DecimalFormat;
import java.util.ArrayList;

/**
 * Created by arnaud on 22/01/16.
 */
public class ListUserAdapter extends ArrayAdapter<User> {

    private final Context context;
    private final ArrayList<User> itemsArrayList;
    private static final String SPACE=" ";

    public ListUserAdapter(Context context, ArrayList<User> itemsArrayList) {

        super(context, R.layout.row_list_users, itemsArrayList);

        this.context = context;
        this.itemsArrayList = itemsArrayList;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View rowView = inflater.inflate( R.layout.row_list_users, parent, false);

        ImageView profilePicture = (ImageView) rowView.findViewById(R.id.UserListImage);
        TextView nameText = (TextView) rowView.findViewById(R.id.UserListName);
        TextView emailText = (TextView) rowView.findViewById(R.id.UserListEmail);

        nameText.setText(itemsArrayList.get(position).getFirstName()+" "+itemsArrayList.get(position).getLastName());
        emailText.setText(itemsArrayList.get(position).getEmail());


        if(itemsArrayList.get(position).getPicture()!=null){
            new ImageDownloader(profilePicture).execute(context.getString(R.string.image_server_path)
                    +itemsArrayList.get(position).getPicture());
        }

        return rowView;
    }
}
