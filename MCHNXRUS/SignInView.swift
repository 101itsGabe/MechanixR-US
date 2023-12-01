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
        VStack {
            Text("Login")
                .bold()
                .font(.system(size: 50))
            TextField("", text:
            $email, prompt: Text("Email")
                .foregroundStyle(Color.gray))
            .padding()
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 5)
                    .foregroundColor(.black))
                
            SecureField("", text:
            $password, prompt: Text("Password")
                .foregroundStyle(Color.gray))
            .padding()
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 5)
                    .foregroundColor(.black))
            VStack{
                
                Button(action: {
                    mxManager.signIn(email: email, password: password)
                }){ Text("Log in").foregroundStyle(Color.black)}
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.gray)
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
                            .foregroundStyle(Color.black)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray))
                
                
            }// end of hstack
            HStack{
                Text("Dont have an account yet?").foregroundStyle(Color.black)
                Button(action:{
                    mxManager.loginScreen = false
                    mxManager.signUpScreen = true
                    
                }){
                    Text("Sign Up")
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    SignInView(mxManager: MXManager())
}
