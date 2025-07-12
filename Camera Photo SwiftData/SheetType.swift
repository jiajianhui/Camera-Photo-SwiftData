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
    
    var id: String {
        String(describing: self)
    }
    
    var body: some View {
        switch self {
        case .new:
            CreateUpdateView(vm: CreateEditViewModel())
        case .update(let sample):
            CreateUpdateView(vm: CreateEditViewModel(sample: sample))
        }
    }
}
