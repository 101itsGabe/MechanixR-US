//
//  SignInView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 11/27/23.
//

import SwiftUI

struct SignInView: View {
    @StateObject var mxManager: MXManager
    @State var email = ""
    @State var password = ""
    @State var signedIn = false
    var body: some View {
        ZStack{
            Color(mxManager.backgroundColor)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Login")
                    .bold()
                    .font(.system(size: 50))
                    .foregroundStyle(Color.white)
                TextField("", text:
                            $email, prompt: Text("Email")
                    .foregroundStyle(Color.white))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                        .foregroundColor(.black))
                
                SecureField("", text:
                                $password, prompt: Text("Password")
                    .foregroundStyle(Color.white))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                        .foregroundColor(.black))
                VStack{
                    
                    Button(action: {
                        mxManager.signIn(email: email, password: password)
                    }){ Text("Log in").foregroundStyle(Color.white)}
                        .padding()
        
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(mxManager.buttonColor)
                        )
                    HStack{
                        VStack{
                            Divider()}
                        Text("or")
                            .foregroundStyle(Color.black)
                        VStack{
                            Divider()
                        }
                    }
                    
                    Button(action: {
                        Task {
                            let success = await mxManager.performGoogleSignin()
                            if success {
                                // Handle successful sign-in
                                print("Sign-in successful")
                                mxManager.loginScreen = false
                                mxManager.signedInScreen = true
                            } else {
                                // Handle failed sign-in
                                print("Sign-in failed")
                            }
                        }
                    }){
                        HStack{
                            Image("Google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                            Text("Sign In With Google")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 15))
                        .foregroundColor(mxManager.buttonColor)
                    
                    
                }// end of hstack
                HStack{
                    Text("Dont have an account yet?").foregroundStyle(Color.black)
                    Button(action:{
                        mxManager.loginScreen = false
                        mxManager.signUpScreen = true
                        
                    }){
                        Text("Sign Up")
                            .foregroundStyle(mxManager.buttonColor)
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    SignInView(mxManager: MXManager())
}
