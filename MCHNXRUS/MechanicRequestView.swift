//
//  MechanicRequestView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/19/23.
//

import SwiftUI

struct MechanicRequestView: View {
    @StateObject var mxManager: MXManager
    @State private var requests: [MyRequest] = []
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            mxManager.backgroundColor
                .ignoresSafeArea(.all)
            VStack{
                List{
                    ForEach(requests, id: \.self){ request in
                        VStack{
                            
                            if(colorScheme == .dark){
                                Text("Email: " + (request.email ?? ""))
                                    .padding()
                                    .foregroundStyle(Color.white)
                            }
                            else{
                                Text("Email: " + (request.email ?? ""))
                                    .padding()
                                    .foregroundStyle(Color.black)
                            }
                            if(colorScheme == .dark){
                                Text("Issue: " + (request.issue ?? "HAZH"))
                                    .foregroundStyle(Color.white)
                                    .padding()
                            }
                            else{
                                Text("Issue: " + (request.issue ?? "HAZH"))
                                    .foregroundStyle(Color.black)
                                    .padding()
                            }
                            if(colorScheme == .dark){
                                Text("Time: " + (request.toReadableTime()))
                                    .padding()
                                    .foregroundStyle(Color.white)
                            }
                            else{
                                Text("Time: " + (request.toReadableTime()))
                                    .padding()
                                    .foregroundStyle(Color.black)
                            }
                            
                            Button(action:{}){
                                Text("Message")
                            }
                            
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .backgroundStyle(mxManager.backgroundColor)
            }
        }
        .onAppear(){
            print("On appear before: \(requests.count)")
            mxManager.getRequests{ recivedRequests in
                requests = recivedRequests
            }
            print("On appear after: \(requests.count)")
        }
    }
}

#Preview {
    MechanicRequestView(mxManager: MXManager())
}
