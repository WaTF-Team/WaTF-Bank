package com.WaTF.WaTFBank;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.OkHttpClient;

public class AccountSummary extends LogoutButton implements View.OnClickListener {

    TextView tvName, tvAccountNo, tvTel, tvBalance;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.account_summary);
        Bundle bundle = getIntent().getExtras();
        boolean flag = bundle.getBoolean("flag");
        if (!flag)
            startActivity(new Intent(this, Login.class));
        tvName = findViewById(R.id.tvName);
        tvAccountNo = findViewById(R.id.tvAccountNo);
        tvTel = findViewById(R.id.tvTel);
        tvBalance = findViewById(R.id.tvBalance);

        String token = getFromSharePref("token");
        String accountNo = getFromSharePref("accountNo");
        AsyncTaskBackGround asyncTaskBackGround = new AsyncTaskBackGround();
        asyncTaskBackGround.execute(token, accountNo);
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
        Intent intent = new Intent(this, Home.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.putExtra("flag", true);
        startActivity(intent);
    }

    private String getFromSharePref(String name) {
        SharedPreferences pref = getApplicationContext().getSharedPreferences("SharePref", MODE_PRIVATE);
        String data = pref.getString(name, null);
        return data;
    }

    private void setScreen(String username, String tel, String balance, String accountNo) {
        tvName.setText(username);
        tvAccountNo.setText(accountNo);
        tvTel.setText(tel);
        tvBalance.setText("$ " + balance);
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent(this, Home.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        intent.putExtra("flag", true);
        startActivity(intent);
    }

    private class AsyncTaskBackGround extends AsyncTask<String, Void, Void> {
        ProgressDialog progressDialog;
        String text = "";
        String message = "";
        String username = "";
        String tel = "";
        String balance = "";
        String accountNo = "";

        @Override
        protected void onPreExecute() {
            progressDialog = ProgressDialog.show(AccountSummary.this,
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
                json = object.toString();
            } catch (JSONException e) {
                e.printStackTrace();
            }
            OkHttpHelper httpHelper = new OkHttpHelper();
            OkHttpClient okHttpClient = httpHelper.getUnsafeOkHttpClient();
            try {
                text = httpHelper.post(getFromSharePref("ip") + getString(R.string.url_accountSummary), json, okHttpClient);
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
                Toast.makeText(AccountSummary.this, "error : connect fail.", Toast.LENGTH_SHORT).show();
            else {
                try {
                    JSONObject jsonObject = new JSONObject(text);
                    message = jsonObject.getString("message");
                    username = jsonObject.getString("username");
                    tel = jsonObject.getString("tel");
                    balance = jsonObject.getString("balance");
                    accountNo = jsonObject.getString("accountNo");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (message.equals("Success")) {
                    setScreen(username, tel, balance, accountNo);
                } else if(message.equals(""))
                    Toast.makeText(AccountSummary.this, "error : connect fail.", Toast.LENGTH_SHORT).show();
                else
                    Toast.makeText(AccountSummary.this, "error : " + message, Toast.LENGTH_SHORT).show();
            }
        }
    }
}
