//
//  UpdateEditeFormViewModel.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/12.
//

import UIKit

@Observable  // @Observable等价于之前的 ObservableObject + @Published
class CreateEditViewModel {
    
    var name: String = ""
    var data: Data?
    
    var image: UIImage {
        if let data, let uiImage = UIImage(data: data) {
            return uiImage
        } else {
            return UIImage()
        }
    }
    
    // 新建数据的话就没有传入sample
    var sample: SampleModel?
    
    // 新建数据
    init() {}
    
    // 更新数据
    init(sample: SampleModel) {
        self.name = sample.name
        self.data = sample.data
        self.sample = sample
    }
    
    
    
    // 清除图片
    @MainActor
    func clearImage() {
        data = nil
    }
    
    // 状态判断
    var isUpdating: Bool {
        sample != nil
    }
    var isDisable: Bool {
        name.isEmpty
    }
}
