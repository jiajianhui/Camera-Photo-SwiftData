//
//  ContentView.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/10.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // 数据查询
    @Query(sort: \SampleModel.name, order: .reverse) var samples: [SampleModel]
    
    @Environment(\.modelContext) private var context
    
    @State private var sheetType: SheetType?
    
    var body: some View {
        NavigationStack {
            
            Group {
                if samples.isEmpty {
                    ContentUnavailableView("please add first photo", systemImage: "photo")
                } else {
                    List(samples) { sample in
        
                        NavigationLink(value: sample) {
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 56, height: 56)
                                .overlay {
                                    if let image = sample.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Image(systemName: "photo")
                                            
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 2)
                                }
                            // 投影问题
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                                
                            
                            HStack {
                                Text(sample.name)
                                    .font(.title)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                context.delete(sample)
                                try? context.save()
                            } label: {
                                Image(systemName: "trash")
                            }

                        }

                    }
                    .listStyle(.plain)
                    
                }
            }
            
            // 导航标题来自模型内容，声明式响应导航目标
            .navigationDestination(for: SampleModel.self, destination: { sample in
                DetailView(sample: sample)
            })
            
            .navigationTitle("List")
            .toolbar {
                ToolbarItem {
                    Button {
                        sheetType = .new
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(item: $sheetType) { $0 }

                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleModel.preview)
}
