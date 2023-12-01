//
//  SignUpView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 11/27/23.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @StateObject var mxManager: MXManager
    @State var email = ""
    @State var password1 = ""
    @State var password2 = ""
    @State var phonenum = ""
    @State var passedE = true
    @State var passedPh = true
    @State var passedP = true
    var body: some View {
        VStack(spacing: 15){
            TextField("", text:
                        $email, prompt: Text("Email")
                .foregroundStyle(Color.gray))
            .padding()
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 4)
                    .foregroundColor(.black))
            TextField("", text:
                        $phonenum, prompt: Text("Phone #")
                .foregroundStyle(Color.gray))
            .padding()
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 4)
                    .foregroundColor(.black))
            SecureField("", text:
                        $password1, prompt: Text("Password")
                .foregroundStyle(Color.gray))
            .padding()
            .foregroundColor(.black)
            .accentColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 4)
                    .foregroundColor(.black))
            SecureField("", text:
                        $password2, prompt: Text("Re-Enter Password")
                .foregroundStyle(Color.gray))
            .padding()
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 4)
                    .foregroundColor(.black))
            Button(action: {
                Task{
                    let numericCharacters = CharacterSet.decimalDigits
                    if !email.contains("@") || email.isEmpty{
                        passedE = false
                    }
                    else{
                        passedE = true
                    }
                    if phonenum.rangeOfCharacter(from: numericCharacters.inverted) != nil || phonenum.isEmpty || phonenum.count > 11{
                        passedPh = false
                    }
                    else{
                        passedPh = true
                    }
                    if password1 != password2 || password1.isEmpty || password2.isEmpty || password1.count < 6 || password2.count < 6{
                        passedP = false
                    }
                    else{
                        passedP = true
                    }
                    
                    if(passedE && passedPh && passedP){
                        mxManager.addUserFromSignUp(email: email, phoneNumber: phonenum)
                        try await mxManager.createNewUser(email: email, password: password2, phoneNum: phonenum)
                        mxManager.curUser.phoneNumber = phonenum
                        mxManager.curUser.email = email
                        mxManager.signUpScreen = false
                        mxManager.signedInScreen = true
                    }
                    
                    
                }}, label: {
                Text("Sign Up!")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.blue)
                    )
            })
            if(!passedE){
                Text("Not a valid email must contain @").padding()
                    .foregroundStyle(Color.red)
            }
            if(!passedPh){
                Text("Not a valid phone number numbers only")
                    .padding()
                    .foregroundStyle(Color.red)
            }
            if(!passedP){
                Text("Passwords dont match!")
                    .padding()
                    .foregroundStyle(Color.red)
            }
        
        }
        
    }
}



#Preview {
    SignUpView(mxManager: MXManager())
}
