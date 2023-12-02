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
        ZStack{
            Color(mxManager.backgroundColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                /*
                HStack{

                    Image("icon2")
                        .resizable()
                        .scaledToFit()
                        .padding()
                    Spacer()
                    Text("MCHNX R'US")
                        .foregroundStyle(Color.white)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    if(mxManager.curUser.imageURL != nil){
                        WebImage(url: mxManager.curUser.imageURL)
                            .scaledToFill()
                            .frame(width: 20, height: 20)
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
                            .scaleEffect(0.3)
                    }
                }
                /*
                Spacer()
                Image("theOne")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.8)
                 */
                 */
                Spacer()
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
                Spacer()
                GeometryReader { geometry in
                    Rectangle()
                        .frame(width: geometry.size.width, height: 4) // Use the width of the screen
                        .foregroundColor(.gray) // Customize the color of the line if needed
                        .offset(y: geometry.size.height)
                }
        
                HStack{
                    Spacer()
                    Button(action:{}){
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                            .padding(.leading)
                        
                    }
                    .padding()
                    Spacer()

                    Spacer()
                    Button(action:{}){
                        Image(systemName: "wrench.adjustable")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                            .padding()
                    }
                    
                    Spacer()

                    Spacer()
                    Button(action:{}){
                        Image(systemName: "cart")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                        .padding()}
                    Spacer()

                    Spacer()
                    Button(action:{}){
                        Image(systemName: "message")
                            .scaleEffect(1.8)
                            .foregroundColor(mxManager.buttonColor)
                            .offset(x:5)
                    }
                    .padding()
                    Spacer()
                    Spacer()

                    Spacer()
                    Button(action:{}){
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
    UserScreen(mxManager: MXManager())
}
