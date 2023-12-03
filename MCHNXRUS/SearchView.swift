//
//  SearcgView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/3/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var mxManager: MXManager
    @State var searchText = ""
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return mxManager.helpOptions
        } else {
            return mxManager.helpOptions.filter { $0.contains(searchText) }
        }
    }
    
    
    var body: some View {
        ZStack{
            mxManager.backgroundColor
                .ignoresSafeArea()
            NavigationStack{
                ZStack{
                    mxManager.backgroundColor
                        .ignoresSafeArea(.all)
                    List{
                        ForEach(searchResults, id: \.self){ name in
                            NavigationLink{
                                Text(name)
                                    .foregroundStyle(Color.white)
                            }
                        label:{
                            Text(name)
                        }
                            
                            
                        }
                    }
                    .navigationTitle("Problems")
                    .foregroundStyle(Color.black)
                }
            }.searchable(text: $searchText, prompt: "Search")
                .foregroundStyle(Color.white)
                .scrollContentBackground(.hidden)
                .toolbarBackground(
                Color(mxManager.backgroundColor)
                , for: .navigationBar)
            
            Spacer()
        }.tint(Color.white)
    }
}

#Preview {
    SearchView(mxManager: MXManager())
}
