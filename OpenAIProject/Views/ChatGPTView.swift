//
//  ContentView.swift
//  OpenAIProject
//
//  Created by christian on 1/12/23.
//

import SwiftUI
import OpenAISwift

// "REPLACE THIS TEXT WITH YOUR OPENAI API KEY"
let openAI = OpenAISwift(authToken: "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")

struct ChatGPTView: View {
    @StateObject var viewModel = ChatViewModel(request: "", response: "", isLoading: false, firstRequest: true)
        
    var body: some View {
        NavigationView {
            VStack {
                ResponseView(viewModel: viewModel)
                
                Section {
                    RequestView(viewModel: viewModel)
                } header: {
                    Text("Chat with Artificial Intelligence.")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                HStack {
                    Button {
                        viewModel.isLoading = true
                        viewModel.firstRequest = false
                        Task {
                            await viewModel.submitRequest(viewModel.request)
                        }
                        
                    } label: {
                        Label("Submit", systemImage: "terminal")
                            .fontWeight(.semibold)
                            .padding(4)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.request.isEmpty || !viewModel.response.isEmpty || viewModel.isLoading)
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis.bubble.fill")
                        .resizable()
                        .frame(width: 34, height: 30)
                        .foregroundColor(viewModel.request.isEmpty ? .secondary : .blue)
                        .opacity(!viewModel.request.isEmpty || viewModel.isLoading ? 1 : 0)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .frame(width: 40, height: 30)
                        .foregroundColor(.yellow)
                        .opacity(viewModel.isLoading ? 1 : 0)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.seal")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor( .green)
                        .opacity(viewModel.request.isEmpty || viewModel.response.isEmpty ? 0 : 1)
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Ask ChatGPT")
        }
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static let viewModel = ChatViewModel.example
    
    static var previews: some View {
        ChatGPTView(viewModel: viewModel)
    }
}
