//
//  ContentView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 11/25/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var mxManager: MXManager
    var body: some View {
        ZStack{
            Color.white
                .edgesIgnoringSafeArea(.all)
            if(mxManager.loginScreen){
                SignInView(mxManager: mxManager)
            }
            else if (mxManager.signedInScreen){
                UserScreen(mxManager: mxManager)
            }
            else if(mxManager.signUpScreen){
                SignUpView(mxManager: mxManager)
            }
        }
    }
}
    

#Preview {
    ContentView(mxManager: MXManager())
}
