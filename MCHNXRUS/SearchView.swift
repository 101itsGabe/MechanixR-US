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
    @Environment(\.colorScheme) var colorScheme
    var isLight : Bool{
        if colorScheme == .dark{
            return false
        }
        else{
            return true
        }
    }
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
                                    .backgroundStyle(mxManager.backgroundColor)
                                    .foregroundStyle(Color.black)
                            }
                        label:{
                            if(isLight){
                                Text(name)
                                    .foregroundStyle(Color(.black))
                            }
                            else{
                                Text(name)
                                    .foregroundStyle(Color(.white))
                            }
                        }
                        .foregroundStyle(mxManager.backgroundColor)
                        .backgroundStyle(mxManager.backgroundColor)
                            
                            
                        }.foregroundStyle(Color.black)
                    }
                    .navigationTitle("Problems")
                    .background(mxManager.backgroundColor)
                }
            }.searchable(text: $searchText, prompt: "Search")
                .background(mxManager.backgroundColor)
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
