package com.WaTF.WaTFBank;

import android.Manifest;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.util.regex.Pattern;

import okhttp3.OkHttpClient;

public class Login extends AppCompatActivity implements View.OnClickListener {

    private static final int MY_PERMISSIONS_REQUEST = 0;
    EditText etUsername, etPassword, etIp1, etIp2, etIp3, etIp4, etPort;
    Button btnLogin;
    private AdView mAdView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        appPermissionRequest();
//        if (isRooted()) {
//            Intent intent = new Intent(this, Root.class);
//            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
//            startActivity(intent);
//        }
        etUsername = findViewById(R.id.etUsername);
        etPassword = findViewById(R.id.etPassword);
        etIp1 = findViewById(R.id.etIp1);
        etIp2 = findViewById(R.id.etIp2);
        etIp3 = findViewById(R.id.etIp3);
        etIp4 = findViewById(R.id.etIp4);
        etPort = findViewById(R.id.etPort);
        btnLogin = findViewById(R.id.btnLogin);
        btnLogin.setOnClickListener(this);
        String ip = getFromSharePref("ip");
        String token = getFromSharePref("token");
        String pin = getFromSharePref("pin");
        if (token != null && pin != null)
            startActivity(new Intent(this, CheckPin.class));
        if (ip != null) {
            String[] ipSplit = ip.split(Pattern.quote("."));
            etIp1.setText(ipSplit[0].split("/")[2]);
            etIp2.setText(ipSplit[1]);
            etIp3.setText(ipSplit[2]);
            etIp4.setText(ipSplit[3].split(":")[0]);
            etPort.setText(ipSplit[3].split(":")[1]);
        }
        mAdView = findViewById(R.id.adView);
        AdRequest adRequest = new AdRequest.Builder().build();
        mAdView.loadAd(adRequest);
    }

    @Override
    public void onClick(View v) {
        if (v == btnLogin) {
            String username = etUsername.getText().toString();
            String password = etPassword.getText().toString();
            if (etIp1.getText().toString().isEmpty() || etIp2.getText().toString().isEmpty() || etIp3.getText().toString().isEmpty() || etIp4.getText().toString().isEmpty() || etPort.getText().toString().isEmpty())
                Toast.makeText(this, "Please set IP", Toast.LENGTH_SHORT).show();
            else {
                String ip = "https://" + etIp1.getText().toString() + "." + etIp2.getText().toString() + "." + etIp3.getText().toString() + "." + etIp4.getText().toString() + ":" + etPort.getText().toString();
                saveToSharePref("ip", ip);
                AsyncTaskBackGround asyncTaskBackGround = new AsyncTaskBackGround();
                asyncTaskBackGround.execute(username, password, ip);
            }
        }
    }

    public static boolean isRooted() {
        boolean root = false;
        String[] places = {"/sbin/", "/system/bin/", "/system/xbin/",
                "/data/local/xbin/", "/data/local/bin/",
                "/system/sd/xbin/", "/system/bin/failsafe/", "/data/local/"};
        for (String where : places) {
            if (new File(where + "su").exists()) {
                root = true;
                break;
            }
        }
        return root;
    }

    private String getFromSharePref(String name) {
        SharedPreferences pref = getApplicationContext().getSharedPreferences("SharePref", MODE_PRIVATE);
        String data = pref.getString(name, null);
        return data;
    }

    private void saveToSharePref(String name, String data) {
        SharedPreferences pref = getApplicationContext().getSharedPreferences("SharePref", MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putString(name, data);
        editor.commit();
    }

    protected void appPermissionRequest() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED)
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.SEND_SMS, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.RECORD_AUDIO, Manifest.permission.ACCESS_FINE_LOCATION}, MY_PERMISSIONS_REQUEST);
    }

    private class AsyncTaskBackGround extends AsyncTask<String, Void, Void> {
        ProgressDialog progressDialog;
        String text = "";
        String message = "";
        String accountNo = "";
        String token = "";

        @Override
        protected void onPreExecute() {
            progressDialog = ProgressDialog.show(Login.this,
                    "ProgressDialog",
                    "Wait Login... ");
        }

        @Override
        protected Void doInBackground(String... params) {
            String json = "";
            try {
                JSONObject object = new JSONObject();
                object.put("username", params[0]);
                object.put("password", params[1]);
                json = object.toString();
            } catch (JSONException e) {
                Log.e("error", "Failed to create JSONObject", e);
            }
            OkHttpHelper httpHelper = new OkHttpHelper();
            OkHttpClient okHttpClient = httpHelper.getUnsafeOkHttpClient();
            try {
                text = httpHelper.post(params[2] + getString(R.string.url_login), json, okHttpClient);
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
                Toast.makeText(Login.this, "error : connect fail.", Toast.LENGTH_SHORT).show();
            else {
                try {
                    JSONObject jsonObject = new JSONObject(text);
                    message = jsonObject.getString("message");
                    accountNo = jsonObject.getString("accountNo");
                    token = jsonObject.getString("token");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (message.equals("Success")) {
                    String password = xor("P@ssw0rd");
                    writeToCipher(password, "username", etUsername.getText().toString());
                    writeToCipher(password, "password", etPassword.getText().toString());
                    Log.d("username", etUsername.getText().toString());
                    Log.d("password", etPassword.getText().toString());
                    saveToSharePref("accountNo", accountNo);
                    saveToSharePref("token", token);
                    Toast.makeText(Login.this, "message : " + message, Toast.LENGTH_SHORT).show();
                    startActivity(new Intent(Login.this, SetPin.class));
                } else if (message.equals(""))
                    Toast.makeText(Login.this, "error : connect fail.", Toast.LENGTH_SHORT).show();
                else
                    Toast.makeText(Login.this, "error : " + message, Toast.LENGTH_SHORT).show();
            }
        }
    }

    private void writeToCipher(String password, String data1, String data2) {
        DatabaseHelperFavoriteAccount database = new DatabaseHelperFavoriteAccount(this);
        database.deleteAll();
        net.sqlcipher.database.SQLiteDatabase.loadLibs(this);
        try {
            File databaseFile = getDatabasePath("credentials.db");
            net.sqlcipher.database.SQLiteDatabase db = net.sqlcipher.database.SQLiteDatabase.openOrCreateDatabase(databaseFile, password, null);
            db.execSQL("CREATE TABLE IF NOT EXISTS secret(key TEXT, value TEXT)");
            db.execSQL("INSERT INTO secret(key, value) VALUES('" + data1 + "', '" + data2 + "')");
            db.close();
        } catch (Exception e) {
            Log.d("error", e.toString());
        }
    }

    private String xor(String data) {
        String key = "k3y";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < data.length(); i++)
            sb.append((char) (data.charAt(i) ^ key.charAt(i % key.length())));
        return sb.toString();
    }
}