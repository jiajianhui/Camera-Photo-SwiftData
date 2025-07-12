//
//  SheetType.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/12.
//

import SwiftUI

enum SheetType: Identifiable, View {
    
    case new
    case update(SampleModel)
    
    // 让枚举遵循 Identifiable 协议，因为 .sheet(item:) 需要一个 Identifiable 类型作为绑定条件。
    var id: String {
        String(describing: self)
    }
    
    // 枚举遵循 View 协议
    var body: some View {
        switch self {
        case .new:
            CreateUpdateView(vm: CreateEditViewModel())
        case .update(let sample):
            CreateUpdateView(vm: CreateEditViewModel(sample: sample))
        }
    }
}
