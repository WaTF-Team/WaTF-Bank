package com.WaTF.WaTFBank;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import okhttp3.OkHttpClient;

public class TransactionHistory extends LogoutButton {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_transaction_history);
        Bundle bundle = getIntent().getExtras();
        boolean flag = bundle.getBoolean("flag");
        if (!flag)
            startActivity(new Intent(TransactionHistory.this, Login.class));
        String token = getFromSharePref("token");
        String accountNo = getFromSharePref("accountNo");
        AsyncTaskBackGround asyncTaskBackGround = new AsyncTaskBackGround();
        asyncTaskBackGround.execute(token, accountNo);
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

    private String getFromSharePref(String name) {
        SharedPreferences pref = getApplicationContext().getSharedPreferences("SharePref", MODE_PRIVATE);
        String data = pref.getString(name, null);
        return data;
    }

    private class AsyncTaskBackGround extends AsyncTask<String, Void, Void> {
        ProgressDialog progressDialog;
        String text = "";
        String message = "";

        @Override
        protected void onPreExecute() {
            progressDialog = ProgressDialog.show(TransactionHistory.this,
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
                Log.e("error", "Failed to create JSONObject", e);
            }
            OkHttpHelper httpHelper = new OkHttpHelper();
            OkHttpClient okHttpClient = httpHelper.getUnsafeOkHttpClient();
            try {
                text = httpHelper.post(getFromSharePref("ip") + getString(R.string.url_transferHistory), json, okHttpClient);
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
                Toast.makeText(TransactionHistory.this, "error : connect fail.", Toast.LENGTH_SHORT).show();
            else {
                try {
                    JSONObject jsonObject = new JSONObject(text);
                    message = jsonObject.getString("message");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (message.equals("Success"))
                    addToList(text);
                else if (message.equals(""))
                    Toast.makeText(TransactionHistory.this, "error : connect fail.", Toast.LENGTH_SHORT).show();
                else
                    Toast.makeText(TransactionHistory.this, "error : " + message, Toast.LENGTH_SHORT).show();
            }
        }
    }

    public void addToList(String text) {
        JSONObject jsonObj = null;
        JSONArray students = null;
        try {
            jsonObj = new JSONObject(text);
            students = jsonObj.getJSONArray("transaction");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        ArrayList<HashMap<String, String>> transaction = new ArrayList();
        for (int i = 0; i < students.length(); i++) {
            HashMap<String, String> item = new HashMap();
            JSONObject c = null;
            try {
                c = students.getJSONObject(i);
                String accountNo = c.getString("accountNo");
                String toAccountNo = c.getString("toAccountNo");
                String amount = c.getString("amount");
                String datetime = c.getString("datetime");
                item.put("account", accountNo);
                item.put("toAccount", toAccountNo);
                item.put("amount", "$ " + amount);
                item.put("datetime", datetime);
                transaction.add(item);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        SimpleAdapter sa = new SimpleAdapter(this, transaction,
                R.layout.activity_listview,
                new String[]{"account", "toAccount", "amount", "datetime"},
                new int[]{R.id.textView1, R.id.textView2, R.id.textView3, R.id.textView4});

        ListView listView = findViewById(R.id.mobile_list);
        listView.setAdapter(sa);
    }
}
