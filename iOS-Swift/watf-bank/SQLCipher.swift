import Foundation

class SQLCipher {
    
    static var kagi = cipherKey()
    static var dbPath = dbURL()
    
    private static func cipherKey() -> String {
        var s = "P@ssw0rd"
        var s2 = "k3yk3yk3"
        let b: [UInt8] = Array(s.utf8)
        let b2: [UInt8] = Array(s2.utf8)
        var k: [UInt8] = Array()
        for i in 0..<b.count {
            k.append(b[i]^b2[i])
        }
        return String(bytes: k, encoding: .utf8)!
    }
    
    private static func dbURL() -> URL {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        url?.appendPathComponent("sqlcipher.db")
        return url!
    }
    
    static func createFav() -> Bool {
        var r = false
        var db: OpaquePointer?
        var key = [CChar]()
        for s in kagi.cString(using: .ascii)! {
            if(s == 0) {
                continue
            }
            key.append(s)
        }
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            sqlite3_key(db, &key, Int32(key.count))
            if sqlite3_exec(db, "create table fav (name text,accountNo text)", nil, nil, nil) == SQLITE_OK {
                r = true
            }
        }
        sqlite3_close(db)
        return r
    }
    
    static func createCred() -> Bool {
        var r = false
        var db: OpaquePointer?
        var key = [CChar]()
        for s in kagi.cString(using: .ascii)! {
            if(s == 0) {
                continue
            }
            key.append(s)
        }
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            sqlite3_key(db, &key, Int32(key.count))
            if sqlite3_exec(db, "create table cred (username text,password text)", nil, nil, nil) == SQLITE_OK {
                r = true
            }
        }
        sqlite3_close(db)
        return r
    }
    
    static func insertFav(_ input: String, _ input2: String) -> Bool {
        var r = false
        var db: OpaquePointer?
        var key = [CChar]()
        for s in kagi.cString(using: .ascii)! {
            if(s == 0) {
                continue
            }
            key.append(s)
        }
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            sqlite3_key(db, &key, Int32(key.count))
            if sqlite3_prepare_v2(db, "insert into fav (name,accountNo) values (?,?)", -1, &stmt, nil) == SQLITE_OK {
                if sqlite3_bind_text(stmt, 1, input, -1, SQLITE_TRANSIENT) == SQLITE_OK {
                    if sqlite3_bind_text(stmt, 2, input2, -1, SQLITE_TRANSIENT) == SQLITE_OK {
                        if sqlite3_step(stmt) == SQLITE_DONE {
                            r=true
                        }
                    }
                }
                sqlite3_finalize(stmt)
            }
        }
        sqlite3_close(db)
        return r
    }
    
    static func insertCred(_ input: String, _ input2: String) -> Bool {
        var r = false
        var db: OpaquePointer?
        var key = [CChar]()
        for s in kagi.cString(using: .ascii)! {
            if(s == 0) {
                continue
            }
            key.append(s)
        }
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            sqlite3_key(db, &key, Int32(key.count))
            if sqlite3_prepare_v2(db, "insert into cred (username,password) values (?,?)", -1, &stmt, nil) == SQLITE_OK {
                if sqlite3_bind_text(stmt, 1, input, -1, SQLITE_TRANSIENT) == SQLITE_OK {
                    if sqlite3_bind_text(stmt, 2, input2, -1, SQLITE_TRANSIENT) == SQLITE_OK {
                        if sqlite3_step(stmt) == SQLITE_DONE {
                            r=true
                        }
                    }
                }
                sqlite3_finalize(stmt)
            }
        }
        sqlite3_close(db)
        return r
    }
    
    static func selectFav(_ input: String) -> Array<String> {
        var db: OpaquePointer?
        var key = [CChar]()
        for s in kagi.cString(using: .ascii)! {
            if(s == 0) {
                continue
            }
            key.append(s)
        }
        var stmt: OpaquePointer?
        var res = Array<String>()
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            sqlite3_key(db, &key, Int32(key.count))
            if sqlite3_prepare_v2(db, "select accountNo from fav where name=\(input)", -1, &stmt, nil) == SQLITE_OK {
                while sqlite3_step(stmt) == SQLITE_ROW {
                    if let data = sqlite3_column_text(stmt, 0) {
                        res.append(String(cString: data))
                    }
                }
                sqlite3_finalize(stmt)
            }
        }
        sqlite3_close(db)
        return res
    }
    
    static func selectCred(_ input: String) -> Array<String> {
        var db: OpaquePointer?
        var key = [CChar]()
        for s in kagi.cString(using: .ascii)! {
            if(s == 0) {
                continue
            }
            key.append(s)
        }
        var stmt: OpaquePointer?
        var res = Array<String>()
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            sqlite3_key(db, &key, Int32(key.count))
            if sqlite3_prepare_v2(db, "select password from cred where username=\(input)", -1, &stmt, nil) == SQLITE_OK {
                while sqlite3_step(stmt) == SQLITE_ROW {
                    if let data = sqlite3_column_text(stmt, 0) {
                        res.append(String(cString: data))
                    }
                }
                sqlite3_finalize(stmt)
            }
        }
        sqlite3_close(db)
        return res
    }
    
    static func selectAll(_ table: String) -> Array<String> {
        var db: OpaquePointer?
        var key = [CChar]()
        for s in kagi.cString(using: .ascii)! {
            if(s == 0) {
                continue
            }
            key.append(s)
        }
        var stmt: OpaquePointer?
        var res = Array<String>()
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            sqlite3_key(db, &key, Int32(key.count))
            if sqlite3_prepare_v2(db, "select * from \(table)", -1, &stmt, nil) == SQLITE_OK {
                while sqlite3_step(stmt) == SQLITE_ROW {
                    if let data = sqlite3_column_text(stmt, 0) {
                        res.append(String(cString: data))
                    }
                }
                sqlite3_finalize(stmt)
            }
        }
        sqlite3_close(db)
        return res
    }
    
    static func drop(_ table: String) -> Bool {
        var r = false
        var db: OpaquePointer?
        var key = [CChar]()
        for s in kagi.cString(using: .ascii)! {
            if(s == 0) {
                continue
            }
            key.append(s)
        }
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            sqlite3_key(db, &key, Int32(key.count))
            if sqlite3_exec(db, "drop table \(table)", nil, nil, nil) == SQLITE_OK {
                r = true
            }
        }
        sqlite3_close(db)
        return r
    }
}
