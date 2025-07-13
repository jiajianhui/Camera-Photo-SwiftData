//
//  UpdateEditeFormViewModel.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/12.
//

import UIKit
import PhotosUI
import SwiftUI

@Observable  // @Observable等价于之前的 ObservableObject + @Published
class CreateEditViewModel {
    
    var name: String = ""
    
    
    // 图片二进制数据
    var data: Data?
    
    // 相机图片
    var cameraImage: UIImage?
    
    // 存储属性，需使用 did set 来监听其变化
    var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    // loadTransferable是一个会抛出错误的函数，必须显式处理 throws 错误，推荐使用do catch处理，使用try?也行但无法定位错误
                    try? await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    
    
    // 方便ui显示；计算属性，无需使用 did set 来监听其变化，每次访问都“现算”
    var image: UIImage {
        if let data, let uiImage = UIImage(data: data) {
            return uiImage
        } else {
            return UIImage()
        }
    }
    
    // 图片数据转为二进制
    @MainActor
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        if let imageData = try await imageSelection?.loadTransferable(type: Data.self) {
            data = imageData
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
        
        // vm的数据与model中的数据连接；编辑模式中维持“原对象指向”的关键
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
