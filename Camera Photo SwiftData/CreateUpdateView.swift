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
                        Button("Camera", systemImage: "camera") {
                            
                        }
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
