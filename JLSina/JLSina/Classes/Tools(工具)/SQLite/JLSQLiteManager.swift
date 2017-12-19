//
//  JLSQLiteManager.swift
//  数据库FMDB
//
//  Created by 盘赢 on 2017/12/18.
//  Copyright © 2017年 盘赢. All rights reserved.
//

import Foundation
import FMDB
//SQLite 管理器
/**
 1,数据库本质上是保存在沙盒中的一个文件，首先需要创建并且打开数据库
    FMDB - 队列
 2,创建数据表
 3,增删改查
 
 提示：数据库开发，程序代码几乎都是一致的，区别在 SQL不同
 开发数据库功能的时候，首先一定要在 navicat 中测试SQL的正确性
 */
 
class JLSQLiteManager {
    
    ///单例，全局数据库工具访问点
    static let shared = JLSQLiteManager()
    
    ///数据库队列
    let queue: FMDatabaseQueue
    
    
    ///构造函数
    private init() {
        
        //数据库的全路径 - path
        let dbName = "status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("数据库的路径\(path)")
        //创建数据库队列,同时创建或者打开数据库
        queue = FMDatabaseQueue(path: path)
        
        //打开数据库
        createTable()
        
        //注册通知 - 监听应用程序进入后台
        //模仿SDWebImage
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearDBCache),
                                               name: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    ///清理数据缓存
    @objc private func clearDBCache() {
        print("清理数据缓存")
    }
}

//MARK: - 微博数据操作
extension JLSQLiteManager {
    
    /*
     思考：从网络加载结束后，返回的是微博的'字典数组',每一个字典对应一个完整的微博记录,
     - 完整的微博记录中，包含微博代号
     - 微博记录中，没有‘当前登录用户代号’
     */
    
    /// 新增或者修改微博数据,在刷新的时候，可能会出现重叠
    ///
    /// - Parameters:
    ///   - userId: 当前登录用户的id
    ///   - array: 从网络获取的‘字典的数组’
    func updateStatus(userId: String , array: [[String: AnyObject]]) {
        //1，准备SQL
        /*
         statusId：  当前要保存的微博代号
         userId：    当前登录用户Id
         status：    完整微博字典的json二进制数据
         */
        let sql = "INSERT OR REPLACE INTO T_Status (statusId , userId , status) VALUES (? , ?, ?);"
        
        //2,执行sql
        queue.inTransaction { (db, rollback) in
            
            //遍历数组,逐条插入微博数据
            for dict in array {
                
                //从字典获取微博代号,将字典序列化成二进制数据
                guard let statusId = dict["idstr"] as? String ,
                      let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                        continue
                }
                
                //执行SQL
                if db.executeUpdate(sql, withArgumentsIn: [statusId , userId , jsonData]) == false {
                    //FIXME:需要回滚 *rollback = YES
                    //Xcode自动语法转换，不会处理此处
                    //Swift 1.x & 2.x => rollback.memory = true
                    //新写法，pointee
                    rollback.pointee = true
                    break
                }
                
                //模拟回滚
//                rollback.pointee = true
//                break
            }
            
        }
    }
}

//MARK: - 创建数据表以及其他私有方法
extension JLSQLiteManager {
    
    
    /// 从数据库加载微博数据数组
    ///
    /// - Parameters:
    ///   - userId: 当前登录的用户账号
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博
    ///   - max_id: 返回ID小于或等于max_id的微博
    /// - Returns: 返回微博的字典的数组,将数据库中 status 字段对应的二进制数据反序列化，生成字典
    func loadStatus(userId: String, since_id: Int64 = 0 ,max_id: Int64 = 0) -> [[String: AnyObject]] {
        
        //1,准备SQL
        var sql = "SELECT statusId , userId , status FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        
        //-- 上拉/下拉，都是针对同一个id进行判断
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        //拼接sql结束后，一定一定要测试
        print(sql)
        
        //2,执行SQL
        let array = execRecordSet(sql: sql)
        
        //3,遍历数组，将数组中的status,反序列化->字典的数组
        var result = [[String: AnyObject]]()
        
        for dict in array {
            
            //反序列化
            guard let jsonData = dict["status"] as? Data ,
                  let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] else {
                continue
            }
            
            //追加到数组
            result.append(json ?? [:])
            
        }
        return result
    }
    
    /// 执行一个sql，返回字典的数组
    ///
    /// - Parameter sql: sql
    /// - Returns: 字典的数组
    func execRecordSet(sql: String) -> [[String: AnyObject]] {
        
        //结果数组
        var result = [[String: AnyObject]]()
        
        
        //执行sql - 查询数据不会修改数据，所以不需要开启事务
        //事务的目的，为了保证数据的有效性，一旦失败，回滚到初始状态
        queue.inDatabase { (db) in
            guard let rs = db.executeQuery(sql, withArgumentsIn: []) else  {
                return
            }
            
            //逐行-遍历结果集合
            while rs.next() {
                //1,列数
                let colCount = rs.columnCount
                
                //2,遍历所有列
                for col in 0..<colCount {
                    //3,取列名 -> key 值 -> value
                    guard let name = rs.columnName(for: col),
                          let value = rs.object(forColumnIndex: col) else {
                            continue
                    }
                    
//                    print("\(name)--\(value)")
                    //4,追加结果
                    result.append([name: value as AnyObject])
                }
            }
            
        }
        
        return result
    }
    
    ///创建数据表
    func createTable() {
        //1，SQL
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil) ,
              let sql = try? String(contentsOfFile: path) else {
            return
        }
        
        //2,执行SQL - FMDB的内部队列，串行队列，同步执行
        //可以保证同一时间，只有一个任务操作数据库，保证数据库的读写安全
        queue.inDatabase { (db) in
            //只有在创表的时候，使用执行多条语句，可以一次创建多个数据表
            //在执行增删改查的时候，一定不要使用executeStatements 方法，否则可能会被注入
            if db.executeStatements(sql) == true {
                print("创表成功")
            } else {
                print("创表失败")
            }
        }
        
        print("---over")
    }
}
