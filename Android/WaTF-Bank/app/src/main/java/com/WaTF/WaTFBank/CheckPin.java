package com.WaTF.WaTFBank;

import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.fingerprint.FingerprintManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.RequiresApi;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class CheckPin extends LogoutButton implements View.OnClickListener {

    EditText etPin;
    TextView tvFingerPrint;
    Button btnSetPin;
    private FingerprintManager mFingerprintManager;
    private FingerprintManager.CryptoObject mCryptoObject;
    private FingerprintHelper mFingerprintHelper;


    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_check_pin);
        etPin = findViewById(R.id.etPin);
        tvFingerPrint = findViewById(R.id.tvFingerPrint);
        btnSetPin = findViewById(R.id.btnSetPin);
        btnSetPin.setOnClickListener(this);
        mFingerprintManager = (FingerprintManager) getSystemService(FINGERPRINT_SERVICE);
        if (mFingerprintManager.isHardwareDetected()) {
            if (mFingerprintManager.hasEnrolledFingerprints()) {
                mFingerprintHelper = new FingerprintHelper(this);
                return;
            }
        }
    }

    @Override
    public void onClick(View view) {
        String pinEnter = etPin.getText().toString();
        if (checkPin(md5(pinEnter))) {
            Intent intent = new Intent(CheckPin.this, Home.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            intent.putExtra("flag", true);
            startActivity(intent);
        } else
            Toast.makeText(CheckPin.this, "Wrong Pin, Please Enter Pin Again.", Toast.LENGTH_SHORT).show();
    }

    public boolean checkPin(String pinEnter) {
        String pin = getFromSharePref("pin");
        return pinEnter.equals(pin);
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

    private String getFromSharePref(String name) {
        SharedPreferences pref = getApplicationContext().getSharedPreferences("SharePref", MODE_PRIVATE);
        String data = pref.getString(name, null);
        return data;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onResume() {
        super.onResume();
        if (mFingerprintHelper != null) {
            mFingerprintHelper.startAuth(mFingerprintManager, mCryptoObject);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onPause() {
        super.onPause();
        if (mFingerprintHelper != null) {
            mFingerprintHelper.stopListening();
        }
    }
}
