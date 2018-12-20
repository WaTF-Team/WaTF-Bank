package com.WaTF.WaTFBank;

import android.content.ContentProvider;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

public class FavoriteAccountProvider extends ContentProvider {
    private DatabaseHelperFavoriteAccount mDatabase;

    @Override
    public boolean onCreate() {
        mDatabase = new DatabaseHelperFavoriteAccount(getContext());
        return true;
    }

    @Override
    public Cursor query(@NonNull Uri uri, @Nullable String[] projection, @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder) {
        SQLiteQueryBuilder queryBuilder = new SQLiteQueryBuilder();
        queryBuilder.setTables(mDatabase.TABLE_NAME);
        return queryBuilder.query(this.mDatabase.getReadableDatabase(), projection, selection, selectionArgs, null, null, sortOrder);
    }

    @Nullable
    @Override
    public String getType(@NonNull Uri uri) {
        return null;
    }

    @Nullable
    @Override
    public Uri insert(@NonNull Uri uri, @Nullable ContentValues values) {
        long id = -1;
        id = this.mDatabase.getWritableDatabase().insert(mDatabase.TABLE_NAME, null, values);
        return ContentUris.withAppendedId(uri, id);
    }

    @Override
    public int delete(@NonNull Uri uri, @Nullable String selection, @Nullable String[] selectionArgs) {
        return this.mDatabase.getWritableDatabase().delete(mDatabase.TABLE_NAME, selection, selectionArgs);
    }

    @Override
    public int update(@NonNull Uri uri, @Nullable ContentValues values, @Nullable String selection, @Nullable String[] selectionArgs) {
        return this.mDatabase.getWritableDatabase().update(mDatabase.TABLE_NAME, values, selection, selectionArgs);
    }
}
