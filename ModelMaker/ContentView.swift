//
//  ContentView.swift
//  ModelMaker
//
//  Created by Yongun Lim on 2023/02/05.
//

import SwiftUI
import Combine
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    private var viewModel = MainViewModel()
    
    @State private var rootName: String = ""
    @State private var inputString: String = ""
    @State private var resultString: String = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text("Root Name")
                        TextField("Enter your name", text: Binding(get: { viewModel.input.rootName.value },
                                                                   set: { viewModel.input.rootName.send($0) }))
                            .padding()
                        Button("Add File", action: insertFile)
                    }
                    .padding(.all, 20)
                    .frame(height: 60)
                    
                    TextEditor(text: Binding(get: { viewModel.input.jsonString.value },
                                             set: { viewModel.input.jsonString.send($0) }))
                        .foregroundColor(.secondary)
                        .font(Font.custom("D2coding", size: 13))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 5))
                }
                .frame(maxWidth: .infinity)
                
                ZStack(alignment: .topTrailing) {
                    TextEditor(text: $resultString)
                        .foregroundColor(.secondary)
                        .font(Font.custom("D2coding", size: 13))
                        .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 20))
                        .onReceive(viewModel.output.result) { value in
                            self.resultString = value
                        }
                    
                    Button("Copy", action: copyResult)
                        .padding(.top, 40)
                        .padding(.trailing, 50)
                }
                .frame(maxWidth: .infinity)
            }
            
            Button("변환", action: actionConvert)
                .padding(.top, 40)
                .padding(.trailing, 50)
        }
        .frame(width: 1200, height: 800)
        .navigationTitle("ModelMaker")
    }
}

extension ContentView {
    private func insertFile() {
        
    }
    
    private func actionConvert() {
        viewModel.input.actionConvert.send(())
    }
    
    private func copyResult() {
        //        viewModel.input.actionConvert.send(())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
