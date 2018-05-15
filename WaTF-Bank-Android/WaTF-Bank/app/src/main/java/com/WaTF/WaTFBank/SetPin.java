package com.WaTF.WaTFBank;

import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.fingerprint.FingerprintManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.RequiresApi;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.multidots.fingerprintauth.FingerPrintAuthCallback;
import com.multidots.fingerprintauth.FingerPrintAuthHelper;
import com.multidots.fingerprintauth.FingerPrintUtils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SetPin extends AppCompatActivity implements View.OnClickListener, FingerPrintAuthCallback {

    TextView tvSetFP;
    EditText etPin;
    Button btnSetPin, btnSetting;
    FingerPrintAuthHelper mFingerPrintAuthHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_set_pin);
        tvSetFP = findViewById(R.id.tvSetFP);
        etPin = findViewById(R.id.etPin);
        btnSetPin = findViewById(R.id.btnSetPin);
        btnSetPin.setOnClickListener(this);
        btnSetting = findViewById(R.id.btnSetting);
        btnSetting.setOnClickListener(this);
        mFingerPrintAuthHelper = FingerPrintAuthHelper.getHelper(this, this);
    }

    @Override
    public void onClick(View view) {
        if (view == btnSetPin) {
            String pin = etPin.getText().toString();
            if (pin.length() < 4)
                Toast.makeText(SetPin.this, "error : Pin must be 4 digit", Toast.LENGTH_SHORT).show();
            else {
                saveToSharePref("pin", md5(pin));
                Intent intent = new Intent(this, Home.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                intent.putExtra("flag", true);
                startActivity(intent);
            }
        } else
            FingerPrintUtils.openSecuritySettings(this);

    }

    private String md5(String in) {
        MessageDigest digest;
        try {
            digest = MessageDigest.getInstance("MD5");
            digest.reset();
            digest.update(in.getBytes());
            byte[] a = digest.digest();
            int len = a.length;
            StringBuilder sb = new StringBuilder(len << 1);
            for (int i = 0; i < len; i++) {
                sb.append(Character.forDigit((a[i] & 0xf0) >> 4, 16));
                sb.append(Character.forDigit(a[i] & 0x0f, 16));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void saveToSharePref(String name, String data) {
        SharedPreferences pref = getApplicationContext().getSharedPreferences("SharePref", MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putString(name, data);
        editor.commit();
    }

    @Override
    protected void onResume() {
        super.onResume();
        tvSetFP.setVisibility(View.GONE);
        btnSetting.setVisibility(View.GONE);
        mFingerPrintAuthHelper.startAuth();
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN)
    @Override
    protected void onPause() {
        super.onPause();
        mFingerPrintAuthHelper.stopAuth();
    }

    @Override
    public void onNoFingerPrintHardwareFound() {
    }

    @Override
    public void onNoFingerPrintRegistered() {
        tvSetFP.setVisibility(View.VISIBLE);
        btnSetting.setVisibility(View.VISIBLE);
    }

    @Override
    public void onBelowMarshmallow() {
    }

    @Override
    public void onAuthSuccess(FingerprintManager.CryptoObject cryptoObject) {
    }

    @Override
    public void onAuthFailed(int errorCode, String errorMessage) {
    }
}
