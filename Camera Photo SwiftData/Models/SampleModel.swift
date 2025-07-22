//
//  SampleModel.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/10.
//

import UIKit
import SwiftData

@Model
class SampleModel {
    
    var name: String = ""
    var createAt: Date = Date.now
    
    @Attribute(.externalStorage)
    var data: Data?
    
    // 计算属性（依赖其他属性），不会被持久化保存（只是一个运行时计算值），类型（UIImage）不支持持久化
    var image: UIImage? {
        if let data {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    
    // 只需要初始化那些没有默认值、不是 Optional、不是计算属性的存储属性
    // 自定义初始化器，让外部传入一个具体的 name来覆盖默认值
    init(name: String) {
        self.name = name
    }
}



// 用于预览的内存数据库容器（类似excel文件）
@MainActor  // 数据操作在主线程安全执行
extension SampleModel {
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: SampleModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        var samples: [SampleModel] {
            [
                .init(name: "01"),
                .init(name: "02")
            ]
        }
        
        samples.forEach {
            container.mainContext.insert($0)
        }
        
        
        return container
    }
}
