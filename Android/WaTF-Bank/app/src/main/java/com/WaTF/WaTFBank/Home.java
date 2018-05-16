package com.WaTF.WaTFBank;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class Home extends LogoutButton implements View.OnClickListener {

    Button btnAccountSummary, btnTransferFavorite, btnTransfer, btnTransactionHistory;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        Bundle bundle = getIntent().getExtras();
        boolean flag = bundle.getBoolean("flag");
        if (!flag)
            startActivity(new Intent(this, Login.class));
        btnAccountSummary = findViewById(R.id.btnAccountSummary);
        btnAccountSummary.setOnClickListener(this);
        btnTransferFavorite = findViewById(R.id.btnTransferFavorite);
        btnTransferFavorite.setOnClickListener(this);
        btnTransfer = findViewById(R.id.btnTransfer);
        btnTransfer.setOnClickListener(this);
        btnTransactionHistory = findViewById(R.id.btnTransactionHistory);
        btnTransactionHistory.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        if (view == btnAccountSummary) {
            Intent intent = new Intent(this, AccountSummary.class);
            intent.putExtra("flag", true);
            startActivity(intent);
        } else if (view == btnTransferFavorite) {
            Intent intent = new Intent(this, TransferFavorite.class);
            intent.putExtra("flag", true);
            startActivity(intent);
        } else if (view == btnTransfer) {
            Intent intent = new Intent(this, Transfer.class);
            intent.putExtra("flag", true);
            startActivity(intent);
        } else if (view == btnTransactionHistory) {
            Intent intent = new Intent(this, TransactionHistory.class);
            intent.putExtra("flag", true);
            startActivity(intent);
        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        Intent intent = new Intent(this, CheckPin.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }
}
