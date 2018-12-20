package com.WaTF.WaTFBank;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

import java.io.File;

public class LogoutButton extends AppCompatActivity {
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.btnLogout:
                removeFromSharePref("token");
                removeFromSharePref("pin");
                removeFromSharePref("accountNo");
                clearCipher();
                clearDB();
                Toast.makeText(this, "Logout", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(this, Login.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(intent);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void removeFromSharePref(String text) {
        SharedPreferences preferences = getSharedPreferences("SharePref", MODE_PRIVATE);
        preferences.edit().remove(text).commit();
    }

    private void clearCipher() {
        File databaseFile = getDatabasePath("credentials.db");
        databaseFile.mkdirs();
        databaseFile.delete();
    }

    private void clearDB(){
        DatabaseHelperFavoriteAccount database = new DatabaseHelperFavoriteAccount(this);
        database.deleteAll();
    }
}
