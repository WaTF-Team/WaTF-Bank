package com.WaTF.WaTFBank;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.widget.TextView;
import android.widget.Toast;

public class TransferResult extends LogoutButton {

    private static final int MY_PERMISSIONS_REQUEST_SEND_SMS = 0;
    TextView tvResult;
    String tel, username, toAccount, amount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_transfer_result);
        Bundle bundle = getIntent().getExtras();
        boolean flag = bundle.getBoolean("flag");
        if (!flag)
            startActivity(new Intent(this, Login.class));
        String message = bundle.getString("message");
        tel = bundle.getString("tel");
        username = bundle.getString("username");
        toAccount = bundle.getString("toAccount");
        amount = bundle.getString("amount");
        tvResult = findViewById(R.id.tvResult);
        tvResult.setText(message);
        sendSMSMessage();
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

    protected void sendSMSMessage() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.SEND_SMS))
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.SEND_SMS}, MY_PERMISSIONS_REQUEST_SEND_SMS);
        } else {
            Intent intent = new Intent();
            intent.setAction("com.WaTF.WaTFBank.Receiver");
            intent.putExtra("tel", tel);
            intent.putExtra("username", username);
            intent.putExtra("toAccount", toAccount);
            intent.putExtra("amount", amount);
            sendBroadcast(intent);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST_SEND_SMS: {
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    sendSMSMessage();
                } else {
                    Toast.makeText(getApplicationContext(),
                            "SMS failed.", Toast.LENGTH_LONG).show();
                    return;
                }
            }
        }
    }
}
