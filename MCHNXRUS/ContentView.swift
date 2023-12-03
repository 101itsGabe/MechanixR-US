//
//  ContentView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 11/25/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var mxManager: MXManager
    @StateObject var uvManager: UVManager
    var body: some View {
        ZStack{
            Color.white
                .edgesIgnoringSafeArea(.all)
            if(mxManager.loginScreen){
                SignInView(mxManager: mxManager)
            }
            else if (mxManager.signedInScreen){
                UserScreen(mxManager: mxManager, uvManager: uvManager)
            }
            else if(mxManager.signUpScreen){
                SignUpView(mxManager: mxManager)
            }
        }
    }
}
    

#Preview {
    ContentView(mxManager: MXManager(), uvManager: UVManager())
}
