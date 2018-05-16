package com.WaTF.WaTFBank;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.OkHttpClient;

public class Transfer extends LogoutButton implements View.OnClickListener {

    EditText etAccount, etAmount;
    Button btnTransfer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_transfer);
        Bundle bundle = getIntent().getExtras();
        boolean flag = bundle.getBoolean("flag");
        if (!flag)
            startActivity(new Intent(Transfer.this, Login.class));
        etAccount = findViewById(R.id.etAccount);
        etAmount = findViewById(R.id.etAmount);
        btnTransfer = findViewById(R.id.btnTransfer);
        btnTransfer.setOnClickListener(this);
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
        startActivity(new Intent(this, CheckPin.class));
    }

    @Override
    public void onClick(View view) {
        if (view == btnTransfer) {
            String token = getFromSharePref("token");
            String accountNo = getFromSharePref("accountNo");
            String toAccountNo = etAccount.getText().toString();
            String amount = etAmount.getText().toString();
            AsyncTaskBackGround asyncTaskBackGround = new AsyncTaskBackGround();
            asyncTaskBackGround.execute(token, accountNo, toAccountNo, amount);
        }
    }

    private String getFromSharePref(String name) {
        SharedPreferences pref = getApplicationContext().getSharedPreferences("SharePref", MODE_PRIVATE);
        String data = pref.getString(name, null);
        return data;
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
            progressDialog = ProgressDialog.show(Transfer.this,
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
            if (text.isEmpty())
                Toast.makeText(Transfer.this, "error : cannot connect to server.", Toast.LENGTH_SHORT).show();
            else {
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
                    Intent intent = new Intent(Transfer.this, TransferResult.class);
                    intent.putExtra("message", message);
                    intent.putExtra("tel", tel);
                    intent.putExtra("username", username);
                    intent.putExtra("toAccount", toAccount);
                    intent.putExtra("amount", amount);
                    intent.putExtra("flag", true);
                    startActivity(intent);
                } else if(message.equals(""))
                    Toast.makeText(Transfer.this, "error : connect fail.", Toast.LENGTH_SHORT).show();
                else {
                    Toast.makeText(Transfer.this, "error : " + message, Toast.LENGTH_SHORT).show();
                    if (message.equals("Invalid token"))
                        startActivity(new Intent(Transfer.this, Login.class));
                }
            }
        }
    }
}