//
//  DataBase.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import SQLite

class DataBase {
    
    static let sharedInstance = DataBase()
    
    private var db: Connection!
    
    private init() {
        do {
            let path = CachesDirectory() + "/db.sqlite3"
            db = try Connection(path)
            
            
//            let users = Table("users")
//            let id = Expression<Int64>("id")
//            let name = Expression<String?>("name")
//            let email = Expression<String>("email")
//
//            
//            try db.run(users.create { t in
//                t.column(id, primaryKey: true)
//                t.column(name)
//                t.column(email, unique: true)
//                })
//            // CREATE TABLE "users" (
//            //     "id" INTEGER PRIMARY KEY NOT NULL,
//            //     "name" TEXT,
//            //     "email" TEXT NOT NULL UNIQUE
//            // )
//            
//            let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
//            let rowid = try db.run(insert)
//            // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')
//            
//            for user in try db.prepare(users) {
//                print("id: \(user[id]), name: \(user[name]), email: \(user[email])")
//                // id: 1, name: Optional("Alice"), email: alice@mac.com
//            }
//            // SELECT * FROM "users"
//            
//            let alice = users.filter(id == rowid)
//            
//            try db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
//            // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
//            // WHERE ("id" = 1)
//            
//            try db.run(alice.delete())
//            // DELETE FROM "users" WHERE ("id" = 1)
//            
//            db.scalar(users.count) // 0
//            // SELECT count(*) FROM "users"
            
        }
        catch {
            print(error)
        }
    }
    
    func create() {
        let list = Table("list")
        let id = Expression<Int64>("id")
        let path = Expression<String>("path")
        let index = Expression<Int>("index")
        do {
            try db.run(list.create(block: { t in
                t.column(id, primaryKey: true)
                t.column(path, unique: true)
                t.column(index)
            }))
        }
        catch {
            
        }
    }
    
    func insert() {
        do {
            let insert = Table("list").insert(Expression<String>("path") <- "AAAA")
            let rowid = try db.run(insert)
            print(rowid)
        }
        catch {
            print(error)
        }
    }
    
    func prepare(){
        
        do {
            let users = Table("users")
            for user in try db.prepare(users) {
                print(user)
            }
            
            let sortArray = try db.prepare(users).sort({ (r1, r2) -> Bool in
                return r1[Expression<Int64>("id")] > r2[Expression<Int64>("id")]
            })
            
            print(sortArray)
        }
        catch {
            print(error)
        }
        
    }
    
    
    
}

