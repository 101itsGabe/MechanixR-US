//
//  RequestFullView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/5/23.
//

import SwiftUI

struct RequestFullView: View {
    @StateObject var mapManager: MapManager
    @StateObject var mxManaer: MXManager
    var body: some View {
        ZStack{
            Color(mxManaer.backgroundColor)
                .ignoresSafeArea(.all)
            VStack{
                if let addy = mapManager.curAddress{
                    Text(addy)
                }
                else
                {
                    Text("Loading addy ...")
                }
            }
            .onAppear(){
                mapManager.getAddress()
            }
        }
    }
}

#Preview {
    RequestFullView(mapManager: MapManager(), mxManaer: MXManager()
    )
}
