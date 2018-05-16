package com.WaTF.WaTFBank;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;

import okhttp3.OkHttpClient;

public class TransferFavorite extends LogoutButton implements View.OnClickListener {

    private Spinner spFavAccount;
    Button btnTransfer, btnAddFav;
    EditText etAmount;
    HashMap<Integer, String> spinnerMap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_transfer_favorite);
        Bundle bundle = getIntent().getExtras();
        boolean flag = bundle.getBoolean("flag");
        if (!flag)
            startActivity(new Intent(TransferFavorite.this, Login.class));
        etAmount = findViewById(R.id.etAmount);
        btnTransfer = findViewById(R.id.btnTransfer);
        btnTransfer.setOnClickListener(this);
        btnAddFav = findViewById(R.id.btnAddFav);
        btnAddFav.setOnClickListener(this);
        spFavAccount = findViewById(R.id.spFavAccount);
        addItemsOnSpinner();
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent(this, Home.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
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
        if (view == btnTransfer) {
            spFavAccount.getSelectedItem();
            String toAccountNo = spinnerMap.get(spFavAccount.getSelectedItemPosition());
            String token = getFromSharePref("token");
            String accountNo = getFromSharePref("accountNo");
            String amount = etAmount.getText().toString();
            if (toAccountNo == null)
                toAccountNo = "";
            AsyncTaskBackGround asyncTaskBackGround = new AsyncTaskBackGround();
            asyncTaskBackGround.execute(token, accountNo, toAccountNo, amount);
        } else if (view == btnAddFav) {
            Intent intent = new Intent(this, AddFavoriteAccount.class);
            intent.putExtra("flag", true);
            startActivity(intent);
        }
    }

    private String getFromSharePref(String name) {
        SharedPreferences pref = getApplicationContext().getSharedPreferences("SharePref", MODE_PRIVATE);
        String data = pref.getString(name, null);
        return data;
    }

    public void addItemsOnSpinner() {
        DatabaseHelperFavoriteAccount mDatabaseHelper = new DatabaseHelperFavoriteAccount(this);
        Cursor data = mDatabaseHelper.showAll();
        String[] spinnerArray = new String[data.getCount()];
        spinnerMap = new HashMap<Integer, String>();
        data.moveToFirst();
        for (int i = 0; i < data.getCount(); i++) {
            String tmpName = data.getString(1).toString();
            String tmpAccountNo = data.getString(2).toString();
            spinnerMap.put(i, tmpAccountNo);
            spinnerArray[i] = tmpName;
            data.moveToNext();
        }
        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, spinnerArray);
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spFavAccount.setAdapter(dataAdapter);
    }

    private class AsyncTaskBackGround extends AsyncTask<String, Void, Void> {
        ProgressDialog progressDialog;
        String text = "";
        String message = "";
        String tel = "";
        String toAccount = "";
        String username = "";
        String amount = "";

        @Override
        protected void onPreExecute() {
            progressDialog = ProgressDialog.show(TransferFavorite.this,
                    "ProgressDialog",
                    "Wait Login... ");
        }

        @Override
        protected Void doInBackground(String... params) {
            String json = "";
            try {
                JSONObject object = new JSONObject();
                object.put("token", params[0]);
                object.put("accountNo", params[1]);
                object.put("toAccountNo", params[2]);
                object.put("amount", params[3]);
                json = object.toString();
            } catch (JSONException e) {
                e.printStackTrace();
            }
            OkHttpHelper httpHelper = new OkHttpHelper();
            OkHttpClient okHttpClient = httpHelper.getUnsafeOkHttpClient();
            try {
                text = httpHelper.post(getFromSharePref("ip") + getString(R.string.url_transfer), json, okHttpClient);
            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            progressDialog.dismiss();
            try {
                JSONObject jsonObject = new JSONObject(text);
                message = jsonObject.getString("message");
                tel = jsonObject.getString("tel");
                username = jsonObject.getString("username");
                toAccount = jsonObject.getString("toAccount");
                amount = jsonObject.getString("amount");
            } catch (JSONException e) {
                e.printStackTrace();
            }
            if (message.equals("Success")) {
                Intent intent = new Intent(TransferFavorite.this, TransferResult.class);
                intent.putExtra("message", message);
                intent.putExtra("tel", tel);
                intent.putExtra("username", username);
                intent.putExtra("toAccount", toAccount);
                intent.putExtra("amount", amount);
                intent.putExtra("flag", true);
                startActivity(intent);
            } else if (message.equals(""))
                Toast.makeText(TransferFavorite.this, "error : connect fail.", Toast.LENGTH_SHORT).show();
            else {
                Toast.makeText(TransferFavorite.this, "error : " + message, Toast.LENGTH_SHORT).show();
                if (message.equals("Invalid token"))
                    startActivity(new Intent(TransferFavorite.this, Login.class));
            }
        }
    }
}
