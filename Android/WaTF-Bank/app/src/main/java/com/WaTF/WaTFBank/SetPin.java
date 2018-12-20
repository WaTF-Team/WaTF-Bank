package com.WaTF.WaTFBank;

import android.Manifest;
import android.app.KeyguardManager;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.hardware.fingerprint.FingerprintManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.RequiresApi;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SetPin extends AppCompatActivity implements View.OnClickListener {

    TextView tvSetFP;
    EditText etPin;
    Button btnSetPin, btnSetting;
    private FingerprintManager mFingerprintManager;
    private KeyguardManager mKeyguardManager;

    @RequiresApi(api = Build.VERSION_CODES.M)
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
        mKeyguardManager = (KeyguardManager) getSystemService(KEYGUARD_SERVICE);
        mFingerprintManager = (FingerprintManager) getSystemService(FINGERPRINT_SERVICE);

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.USE_FINGERPRINT) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
//        else
//            Toast.makeText(this, "Fingerprint enabled", Toast.LENGTH_SHORT).show();

        if (mFingerprintManager.isHardwareDetected()) {
            if (!mKeyguardManager.isKeyguardSecure()) {
                Toast.makeText(this, "Please set pin", Toast.LENGTH_SHORT).show();
                return;
            }
            if (!mFingerprintManager.hasEnrolledFingerprints()) {
                tvSetFP.setVisibility(View.VISIBLE);
                btnSetting.setVisibility(View.VISIBLE);
                return;
            }
        } else
            Toast.makeText(this, "No hardware", Toast.LENGTH_SHORT).show();
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
        } else if (view == btnSetting)
            startActivity(new Intent(android.provider.Settings.ACTION_SECURITY_SETTINGS));
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
}
