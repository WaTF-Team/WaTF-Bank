package com.WaTF.WaTFBank;

import android.app.Dialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class Root extends AppCompatActivity {
    Button btnAboutme;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_root);
        btnAboutme = findViewById(R.id.btnAboutme);
        btnAboutme.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ShowPopup();
            }
        });
    }

    public void ShowPopup() {
        Dialog myDialog = new Dialog(this);
        myDialog.setContentView(R.layout.activity_about);
        myDialog.show();
    }
}
