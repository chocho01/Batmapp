package com.epsi.batmapp.activity;

import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.view.View;
import android.widget.ImageView;

import com.epsi.batmapp.R;
import com.epsi.batmapp.helper.ImageDownloader;
import com.epsi.batmapp.model.Session;

import java.util.concurrent.ExecutionException;

public class DetailUser extends AppCompatActivity {

    private static final int SELECTED_PICTURE = 1;
    private ImageView img;
    private String selectedImagePath;
    private Session session;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail_user);
        session = Session.getInstance(null);
        img = (ImageView) findViewById(R.id.imageViewDetailUser);

        ImageDownloader downloader =  new ImageDownloader();
        downloader.execute(getString(R.string.image_server_path)+session.getUserConnected().getPicture());

        try {
            img.setImageBitmap(downloader.get());
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }

    }

    public void openGallery(View view){
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Select file to upload "), SELECTED_PICTURE);
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (resultCode == RESULT_OK) {
            if (requestCode == SELECTED_PICTURE) {
                Uri selectedImageUri = data.getData();
                selectedImagePath = getPath(selectedImageUri);

                BitmapFactory.Options options = new BitmapFactory.Options();
                options.inPreferredConfig = Bitmap.Config.ARGB_8888;
                Bitmap bitmap = BitmapFactory.decodeFile(selectedImagePath, options);

                bitmap = ImageDownloader.getRoundedCornerBitmap(bitmap);
                img.setImageBitmap(bitmap);

                //TODO envoyer l'image au serveur
            }
        }
    }

    public String getPath(Uri uri){
        String[] projection = { MediaStore.Images.Media.DATA };
        Cursor cursor = managedQuery(uri, projection, null, null, null);
        if (cursor == null) return null;
        int column_index =             cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToFirst();
        String s=cursor.getString(column_index);
        cursor.close();
        return s;
    }
}
