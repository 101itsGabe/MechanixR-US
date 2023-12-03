//
//  UserAccountView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/2/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserAccountView: View {
    @StateObject var mxManager: MXManager
    var body: some View {
        ZStack{
            Color(mxManager.backgroundColor).ignoresSafeArea(.all)
            VStack{
                Text("User is succsefully signed in")
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                if(mxManager.curUser.userType == 1)
                {
                    Text("UserType: Customer")
                        .padding()
                        .bold()
                        .foregroundColor(.white)
                }
                else{
                    Text("UserType: Contractor")
                        .padding()
                        .bold()
                        .foregroundColor(.white)
                }
                Text(mxManager.curUser.email ?? "no email")
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                Text(mxManager.curUser.phoneNumber ?? "no phone")
                    .foregroundColor(.white)
                    .bold()
                ZStack{
                    Circle()
                        .fill(Color.black)
                        .frame(width: 100, height: 100)
                    if let url = mxManager.curUser.imageURL{
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 85,height: 85)
                            .padding()
                        
                    }
                    else{
                        Image("default")
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(1.5)
                            .frame(width: 90,height: 90)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black))
                            .padding()
                        
                        
                    }
                }
                Spacer()
                Button(action:{
                    mxManager.signOutUser()
                }){Text("Sign Out")}
                    .padding()
                    .foregroundStyle(mxManager.buttonColor)
            }
        }
    }
}

#Preview {
    UserAccountView(mxManager: MXManager())
}
