//
//  ContentView.swift
//  ModelMaker
//
//  Created by Yongun Lim on 2023/02/05.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    private let viewModel = MainViewModel()
    
    @State private var rootName: String = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Root Name")
                    TextField("Enter your name", text: $rootName)
                            .padding()
                    Button("Add File", action: insertFile)
                }
                .padding(.all, 20)
                .frame(height: 60)
                
                let content = """
"manage": {
    "dummy": false,
    "reRegistered": false,
    "webReserved": false,
    "registDateTime": "2022-06-27T14:25:28",
    "firstAdvertisedDateTime": "2022-06-27T14:28:30",
    "modifyDateTime": "2022-09-22T08:34:01",
    "subscribeCount": 13,
    "viewCount": 1307
},
"""
                DefaultTextView(content: content)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 5))
            }
            .frame(maxWidth: .infinity)
            
            ZStack(alignment: .topTrailing) {
                DefaultTextView()
                    .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 0))
                
                Button("Copy", action: copyResult)
                    .padding(.top, 40)
                    .padding(.trailing, 40)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 1200, height: 800)
        .navigationTitle("ModelMaker")
    }
    
    struct DefaultTextView: View {
        
        @State var content: String = ""
        
        var body: some View {
            TextEditor(text: $content)
                .foregroundColor(.secondary)
                .font(Font.custom("D2coding", size: 13))
                
        }
    }
}

extension ContentView {
    private func insertFile() {
        
    }
    
    private func copyResult() {
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
