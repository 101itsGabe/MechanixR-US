//
//  UserScreen.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 11/27/23.
//

import SwiftUI
import SDWebImageSwiftUI
struct UserScreen: View {
    @StateObject var mxManager: MXManager
    @StateObject var uvManager: UVManager
    @StateObject var mapManager: MapManager
    var body: some View {
        ZStack{
            Color(mxManager.backgroundColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                if(uvManager.ifUserAccount){
                    UserAccountView(mxManager: mxManager)
                }
                
                else if uvManager.ifShop{
                    Text("Shop goes here")
                        .foregroundStyle(Color.white)
                }
                else if uvManager.ifSearch{
                    SearchView(mxManager: mxManager)
                        .foregroundStyle(Color.white)
                }
                else if uvManager.ifRequest{
                    if(mxManager.curUser.userType == 1){
                        RequestView(mxManager: mxManager, mapManager: mapManager)
                            .foregroundStyle(Color.white)
                    }
                    else{
                        MechanicRequestView(mxManager: mxManager)
                    }
                }
                else if uvManager.ifMessages{
                    Text("Messages goes here")
                        .foregroundStyle(Color.white)
                }
                
                Rectangle()
                    .frame(height: 4) // Adjust width as needed
                    .foregroundColor(.gray)
        
                HStack{
                    Spacer()
                    Button(action:{uvManager.ifUserAccount = false
                        uvManager.ifMessages = false
                        uvManager.ifSearch = false
                        uvManager.ifRequest = false
                        uvManager.ifShop = true}){
                        Image(systemName: "cart")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                            .padding(.leading)
                        
                    }
                    .padding()
                    Spacer()

                    Spacer()
                    Button(action:{uvManager.ifUserAccount = false
                        uvManager.ifMessages = false
                        uvManager.ifSearch = false
                        uvManager.ifRequest = true
                        uvManager.ifShop = false}){
                        Image(systemName: "wrench.adjustable")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                            .padding()
                    }
                    
                    Spacer()

                    Spacer()
                    Button(action:{uvManager.ifUserAccount = false
                        uvManager.ifMessages = false
                        uvManager.ifSearch = true
                        uvManager.ifRequest = false
                        uvManager.ifShop = false}){
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                        .padding()}
                    Spacer()

                    Spacer()
                    Button(action:{uvManager.ifUserAccount = false
                        uvManager.ifMessages = true
                        uvManager.ifSearch = false
                        uvManager.ifRequest = false
                        uvManager.ifShop = false}){
                        Image(systemName: "message")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                            .offset(x:5)
                    }
                    .padding()
                    Spacer()
                    Spacer()

                    Spacer()
                    Button(action:{
                        uvManager.ifUserAccount = true
                        uvManager.ifMessages = false
                        uvManager.ifSearch = false
                        uvManager.ifRequest = false
                        uvManager.ifShop = false
                    }){
                        Image(systemName: "person.circle")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                            .padding(.trailing)
                    }
                    .padding()
                    
                }
            }//Vstack
        }
        }
    }

#Preview {
    UserScreen(mxManager: MXManager(),
                uvManager: UVManager(), mapManager: MapManager())
}
