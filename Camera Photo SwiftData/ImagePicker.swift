//
//  ImagePicker.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/12.
//

import SwiftUI
import PhotosUI


@Observable
class ImagePicker {
    
    var vm: CreateEditViewModel?
    
    func setup(_ vm: CreateEditViewModel) {
        self.vm = vm
    }
    
    // 与图片选择器相关的变属性
    var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    
    
    // 将图片转为二进制
    @MainActor
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                vm?.data = data
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
