package com.WaTF.WaTFBank;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class AddFavoriteAccount extends LogoutButton implements View.OnClickListener {

    DatabaseHelperFavoriteAccount mDatabase;
    EditText etName, etAccountNo;
    Button btnAdd;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_favorite_account);
        Bundle bundle = getIntent().getExtras();
        boolean flag = bundle.getBoolean("flag");
        if (!flag)
            startActivity(new Intent(this, Login.class));
        etName =  findViewById(R.id.etName);
        etAccountNo =  findViewById(R.id.etAccountNo);
        btnAdd =  findViewById(R.id.btnAdd);
        btnAdd.setOnClickListener(this);
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent(this, TransferFavorite.class);
        intent.putExtra("flag", true);
        startActivity(intent);
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        Intent intent = new Intent(this, CheckPin.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }

    @Override
    public void onClick(View view) {
        String name = etName.getText().toString();
        String accountNo = etAccountNo.getText().toString();
        mDatabase = new DatabaseHelperFavoriteAccount(getApplicationContext());
        mDatabase.addData(name, accountNo);
        Toast.makeText(this, "Add account successfully", Toast.LENGTH_SHORT).show();
        Intent intent = new Intent(this, Home.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.putExtra("flag", true);
        startActivity(intent);
    }
}