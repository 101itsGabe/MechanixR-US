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
    var body: some View {
        VStack{
            
            HStack{
                Spacer()
                Text("MCHNX R'US")
                    .foregroundStyle(Color.black)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .multilineTextAlignment(.center)
                if(mxManager.curUser.imageURL != nil){
                    WebImage(url: mxManager.curUser.imageURL)
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 10))
                        .scaleEffect(0.5)
                }
                else
                {
                    Image("default")
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 10))
                        .scaleEffect(0.5)
                }
            }
            Spacer()
            Text("User is succsefully signed in")
                .padding()
                .foregroundColor(.black)
            Text(mxManager.curUser.email ?? "no email")
                .padding()
                .foregroundColor(.black)
            Text(mxManager.curUser.phoneNumber ?? "no phone")
                .foregroundColor(.black)
            Spacer()
            }
        }
    }

#Preview {
    UserScreen(mxManager: MXManager())
}
