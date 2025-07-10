//
//  Camera_Photo_SwiftDataApp.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/10.
//

import SwiftUI
import SwiftData

@main
struct Camera_Photo_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // 创建容器、注册 SampleModel 模型、注入 SwiftUI 环境中
        .modelContainer(for: SampleModel.self)
    }
}
