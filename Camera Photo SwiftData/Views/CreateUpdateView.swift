//
//  CreateUpdateView.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/12.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateUpdateView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State var vm: CreateEditViewModel
    
    // 展示相机
    @State private var showCamera = false
    // 相机权限错误
    @State private var cameraError: CameraPermission.CameraError?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("name", text: $vm.name)
                
                VStack {
                    if vm.data != nil {
                        Button("Clear Image") {
                            vm.clearImage()
                        }
                    }
                    
                    HStack {
                        
                        // 相机按钮
                        Button("Camera", systemImage: "camera") {
                            // 检查权限
                            if let error = CameraPermission.checkPermission() {
                                cameraError = error
                            } else {
                                showCamera.toggle()
                            }
                            
                        }
                        // 错误信息
                        .alert(isPresented: .constant(cameraError != nil), error: cameraError) { _ in
                            Button("OK") {
                                cameraError = nil
                            }
                        } message: { error in
                            Text(error.recoverySuggestion ?? "请再次尝试")
                        }
                        // 相机界面
                        .sheet(isPresented: $showCamera) {
                            UIKitCamera(selectedImage: $vm.cameraImage)
                                .ignoresSafeArea()
                        }

                        
                        
                        // 图库按钮
                        PhotosPicker(selection: $vm.imageSelection) {
                            Label("Photos", systemImage: "photo")
                        }
                        
                    }
                    .foregroundStyle(.white)
                    .buttonStyle(.borderedProminent)
                    
                    Image(uiImage: vm.image)
                        .resizable()
                        .scaledToFit()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let imageData = vm.image != UIImage() ? vm.image.jpegData(compressionQuality: 0.7) : nil
                        
                        if vm.isUpdating, let sample = vm.sample {
                            // 更新
                            sample.name = vm.name
                            sample.data = imageData
                        } else {
                            // 新建
                            let newSample = SampleModel(name: vm.name)
                            newSample.data = imageData
                            context.insert(newSample)
                        }
                        
                        // 保存、关闭sheet
                        try? context.save()
                        dismiss()
                        
                    } label: {
                        Text(vm.isUpdating ? "Update" : "Add")
                    }
                    .disabled(vm.isDisable)
                }
            }
        }
        
    }
}

#Preview {
    CreateUpdateView(vm: CreateEditViewModel())
}
