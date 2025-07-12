//
//  DetailView.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/10.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    
    let sample: SampleModel
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var sheetType: SheetType?
    
    var body: some View {
        ScrollView {
            VStack {
                Text(sample.name)
                    .font(.title)
                
                
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .overlay {
                        if let image = sample.image {
                            Image(uiImage: image)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 36))
                
                    
                    .overlay {
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(Color.white, lineWidth: 4)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                
                // btns
                HStack(spacing:40) {
                    Button {
                        sheetType = .update(sample)
                    } label: {
                        Text("编辑")
                    }
                    .sheet(item: $sheetType) { sheet in
                        sheet
                    }
                    
                    Button(role: .destructive) {
                        context.delete(sample)
                        try? context.save()
                        dismiss()
                    } label: {
                        Text("删除")
                    }

                }
                .buttonStyle(.borderedProminent)
                .padding()
                .padding(.top)
                    
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(sample.name)
    }
}

#Preview {
    let container = SampleModel.preview
    let fetchDescriptor = FetchDescriptor<SampleModel>()
    let sample = try! container.mainContext.fetch(fetchDescriptor)[0]
    
//    let sample = SampleModel(name: "hello")
    return NavigationStack {
        DetailView(sample: sample)
    }
    .modelContainer(container)
}
