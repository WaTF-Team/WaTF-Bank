#import "SqlCipher.h"

@interface SqlCipher()
@end

@implementation SqlCipher

static NSString *kagi;

+(void)cipherKey
{
    NSString *s = @"P@ssw0rd";
    NSString *s2 = @"k3yk3yk3";
    NSMutableString *k = [[NSMutableString alloc] init];
    NSMutableString *r = [[NSMutableString alloc] init];
    for (int i=0; i<s.length; i++) {
        char c = [s characterAtIndex:i] ^ [s2 characterAtIndex:i];
        if([NSString stringWithFormat:@"%x",c].length==1)
        {
            [k appendFormat:@"%x",0];
        }
        [k appendFormat:@"%x",c];
    }
    for (int i=0; i<[k length]; i+=2)
    {
        NSString * hexChar = [k substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [r appendFormat:@"%c", (char)value];
    }
    kagi = r;
}

+(BOOL)create
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    bool valid = false;
    
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if (sqlite3_exec(db, (const char*) "CREATE TABLE fav (name text,accountNo text)", NULL, NULL, NULL) == SQLITE_OK) {
            valid = true;
        }
        sqlite3_close(db);
    }
    return valid;
}

+(BOOL)create2
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    bool valid = false;
    
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if (sqlite3_exec(db, (const char*) "CREATE TABLE cred (username text,password text)", NULL, NULL, NULL) == SQLITE_OK) {
            valid = true;
        }
        sqlite3_close(db);
    }
    return valid;
}

+(BOOL)insert:(NSString*)input :(NSString*)input2
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    bool valid = false;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@(\"%@\",\"%@\")",@"INSERT INTO fav (name,accountNo) values ",input,input2] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if (sqlite3_exec(db, q, NULL, NULL, NULL) == SQLITE_OK) {
            valid = true;
        }
        sqlite3_close(db);
    }
    return valid;
}

+(BOOL)insert2:(NSString*)input :(NSString*)input2
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    bool valid = false;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@(\"%@\",\"%@\")",@"INSERT INTO cred (username,password) values ",input,input2] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if (sqlite3_exec(db, q, NULL, NULL, NULL) == SQLITE_OK) {
            valid = true;
        }
        sqlite3_close(db);
    }
    return valid;
}

+(BOOL)del:(NSString*)input
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    bool valid = false;
    
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@%@",@"DELETE FROM fav WHERE name=",input] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if (sqlite3_exec(db, q, NULL, NULL, NULL) == SQLITE_OK) {
            valid = true;
        }
        sqlite3_close(db);
    }
    return valid;
}

+(BOOL)del2:(NSString*)input
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    bool valid = false;
    
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@%@",@"DELETE FROM cred WHERE username=",input] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if (sqlite3_exec(db, q, NULL, NULL, NULL) == SQLITE_OK) {
            valid = true;
        }
        sqlite3_close(db);
    }
    return valid;
}

+(NSString*)select:(NSString*)input
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    sqlite3_stmt *stmt;
    bool sqlcipher_valid = NO;
    NSString *res=nil;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@\"%@\"",@"SELECT accountNo FROM fav WHERE name=",input] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
            if(sqlite3_prepare_v2(db, q, -1, &stmt, NULL) == SQLITE_OK) {
                if(sqlite3_step(stmt)== SQLITE_ROW) {
                    const char *acc = (const char *)sqlite3_column_text(stmt, 0);
                    if(acc != NULL) {
                        sqlcipher_valid = YES;
                        res=[NSString stringWithUTF8String:acc];
                    }
                }
                sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    if(sqlcipher_valid)
        return res;
    else
        return nil;
}

+(NSString*)select2:(NSString*)input
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    sqlite3_stmt *stmt;
    bool sqlcipher_valid = NO;
    NSString *res=nil;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@\"%@\"",@"SELECT password FROM cred WHERE username=",input] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if(sqlite3_prepare_v2(db, q, -1, &stmt, NULL) == SQLITE_OK) {
            if(sqlite3_step(stmt)== SQLITE_ROW) {
                const char *acc = (const char *)sqlite3_column_text(stmt, 0);
                if(acc != NULL) {
                    sqlcipher_valid = YES;
                    res=[NSString stringWithUTF8String:acc];
                }
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    if(sqlcipher_valid)
        return res;
    else
        return nil;
}

+(NSMutableArray*)selectAll
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    sqlite3_stmt *stmt;
    bool sqlcipher_valid = NO;
    NSMutableArray *res = [[NSMutableArray alloc] init];
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@",@"SELECT * FROM fav"] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
            if(sqlite3_prepare_v2(db, q, -1, &stmt, NULL) == SQLITE_OK) {
                while(sqlite3_step(stmt)==SQLITE_ROW) {
                    const char *name = (const char *)sqlite3_column_text(stmt, 0);
                    if(name != NULL) {
                        sqlcipher_valid = YES;
                        [res addObject:[NSString stringWithUTF8String:name]];
                    }
                }
                sqlite3_finalize(stmt);
            }
        sqlite3_close(db);
    }
    return res;
}

+(NSMutableArray*)selectAll2
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    sqlite3_stmt *stmt;
    bool sqlcipher_valid = NO;
    NSMutableArray *res = [[NSMutableArray alloc] init];
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@",@"SELECT * FROM cred"] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if(sqlite3_prepare_v2(db, q, -1, &stmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(stmt)==SQLITE_ROW) {
                const char *name = (const char *)sqlite3_column_text(stmt, 0);
                if(name != NULL) {
                    sqlcipher_valid = YES;
                    [res addObject:[NSString stringWithUTF8String:name]];
                }
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    return res;
}

+(BOOL)drop:(NSString*)input
{
    [self cipherKey];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    sqlite3 *db;
    bool valid = false;
    
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [kagi UTF8String];
        const char* q = [[NSString stringWithFormat:@"%@%@",@"DROP TABLE ",input] UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if (sqlite3_exec(db, q, NULL, NULL, NULL) == SQLITE_OK) {
            valid = true;
        }
        sqlite3_close(db);
    }
    return valid;
}

@end
