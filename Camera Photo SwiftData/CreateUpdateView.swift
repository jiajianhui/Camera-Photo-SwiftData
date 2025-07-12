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
    
    @State private var imagePicker = ImagePicker()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("name", text: $vm.name)
                
                VStack {
                    if vm.data != nil {
                        Button("Clear Image") {
                            vm.data = nil
                        }
                    }
                    
                    HStack {
                        Button("Camera", systemImage: "camera") {
                            
                        }
                        PhotosPicker(selection: $imagePicker.imageSelection) {
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
            .onAppear {
                imagePicker.setup(vm)
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if vm.isUpdating {
                            
                            // Update
                            if let sample = vm.sample {
                                if vm.image != UIImage() {
                                    sample.data = vm.image.jpegData(compressionQuality: 0.7)
                                } else {
                                    sample.data = nil
                                }
                                sample.name = vm.name
                                dismiss()
                            }
                        } else {
                            
                            // Add
                            let newSample = SampleModel(name: vm.name)
                            if vm.image != UIImage() {
                                newSample.data = vm.image.jpegData(compressionQuality: 0.7)
                            } else {
                                newSample.data = nil
                            }
                            context.insert(newSample)
                            dismiss()
                        }
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
