//
//  RequestFullView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/5/23.
//

import SwiftUI

struct RequestFullView: View {
    @StateObject var mapManager: MapManager
    @StateObject var mxManager: MXManager
    @State var selectedObject = 0
    @State private var emails: [String] = []
    @State var address = ""
    @State var searchText = ""
    @State var Wrongtext = ""
    @Environment(\.colorScheme) var colorScheme
    var searchResults: [String] {
        if searchText.isEmpty {
            return mxManager.helpOptions
        } else {
            return mxManager.helpOptions.filter { $0.contains(searchText) }
        }
    }
    var body: some View {
        ZStack{
            Color(mxManager.backgroundColor)
                .ignoresSafeArea(.all)
            VStack{
                HStack{
                    Button(action:{
                        mxManager.requestScreen = false
                        mxManager.signedInScreen = true
                    }){
                        Image(systemName: "x.circle.fill")
                            .scaleEffect(1.5)
                            .foregroundColor(mxManager.buttonColor)
                            .padding()
                            .offset(x:20)
                        Spacer()
                    }
                }
                
                Spacer().frame(maxHeight: 1)
                
                Text(mapManager.curAddress ?? "No Address Found")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 4)
                        .foregroundColor(.black)
                        .frame(minHeight: 30)
                    ).foregroundStyle(Color.white)
                    .padding()
                Spacer()
                
                /*
                List(emails.prefix(3), id: \.self) { email in
                            Text(email)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .onAppear {
                    // Call the function to retrieve emails of users with status true
                    mxManager.getContractors{ emailsList in
                    // Update the @State variable to refresh the UI
                    self.emails = emailsList
                    }
                }
                .padding()
                .frame(maxHeight: 500)
                 */
                    List{
                        ForEach(0..<mxManager.helpOptions.count, id: \.self){ index in
                            Button(action:{
                                selectedObject = index
                                mxManager.selectedRequest = index
                            }){
                                if(selectedObject == index){
                                    Text(mxManager.helpOptions[index])
                                        .foregroundStyle(mxManager.buttonColor)
                                        .bold()
                                }
                                else{
                                    if(colorScheme == .dark){
                                        Text(mxManager.helpOptions[index])
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                    else{
                                        Text(mxManager.helpOptions[index])
                                            .foregroundStyle(Color.black)
                                            .bold()
                                    }
                                }
                            }
                            
                        }
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                    .foregroundStyle(mxManager.backgroundColor)
                    .background(mxManager.backgroundColor)
                    Spacer()
                    Button(action:{
                        mxManager.requestScreen = false
                        mxManager.carInfoScreen = true
                    }){
                        Text("Add Car Info")
                        .foregroundStyle(Color.white)}
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(mxManager.buttonColor))
            }
        }
    }
}

#Preview {
    RequestFullView(mapManager: MapManager(), mxManager: MXManager()
    )
}
