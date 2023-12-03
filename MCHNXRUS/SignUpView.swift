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
    @State var passedEFirebase = true
    @State var passedPh = true
    @State var passedP = true
    @State var selected = 1
    var body: some View {
        ZStack{
            Color(mxManager.backgroundColor)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 15){
                Text("SIGN UP")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                Spacer()
                TextField("", text:
                            $email, prompt: Text("Email")
                    .foregroundStyle(Color.white))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 4)
                        .foregroundColor(.black))
                TextField("", text:
                            $phonenum, prompt: Text("Phone #")
                    .foregroundStyle(Color.white))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 4)
                        .foregroundColor(.black))
                SecureField("", text:
                                $password1, prompt: Text("Password")
                    .foregroundStyle(Color.white))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 4)
                        .foregroundColor(.black))
                SecureField("", text:
                                $password2, prompt: Text("Re-Enter Password")
                    .foregroundStyle(Color.white))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 4)
                        .foregroundColor(.black))
                
                Picker(selection: $selected, label: Text("Customer Or Contractor")){
                    Text("Customer").tag(1)
                    Text("Contractor").tag(2)
                }
                .pickerStyle(.palette)
                .padding()
                
                Spacer()
                
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
                        print("HELLOOOOO")
                        print(mxManager.isInFirebase)
                        
                        await mxManager.getUserFromDatabase(email: email)
                        print("THE EMAIL: \(email)")
                        print("after getUser: \(mxManager.isInFirebase)")
                        if(mxManager.isInFirebase == true){
                            print("YES Lawd")
                            passedEFirebase = false
                            
                        }
                        else{
                            print("NO Lawd")
                            passedEFirebase = true
                        }

                        //Shiloh@gmail.com
                        if(passedE && passedPh && passedP && passedEFirebase){
                            mxManager.addUserFromSignUp(email: email, phoneNumber: phonenum, userType: selected)
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
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(mxManager.buttonColor)
                            )
                    })
                
                if !passedEFirebase{
                    Text("User is already registered!")
                        .foregroundStyle(Color.red)
                        .bold()
                }
                
                if(!passedE){
                    Text("Not a valid email must contain @")
                        .foregroundStyle(Color.red)
                        .bold()
                }
                if(!passedPh){
                    Text("Not a valid phone number numbers only")
                        .foregroundStyle(Color.red)
                        .bold()
                }
                if(!passedP){
                    Text("Passwords dont match!")
                        .foregroundStyle(Color.red)
                        .bold()
                }
                
            }
            .padding()
        }
        
    }
}



#Preview {
    SignUpView(mxManager: MXManager())
}
