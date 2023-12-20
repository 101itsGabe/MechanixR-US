//
//  RequestView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/3/23.
//

import SwiftUI
import MapKit
import CoreLocation
struct MapView: UIViewRepresentable {
    var userLocation: CLLocationCoordinate2D?
    @ObservedObject var mapManager: MapManager
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        if let region = mapManager.region{
            mapView.setRegion(region, animated: true)
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map view here if needed
        if let region = mapManager.region {
            uiView.setRegion(region, animated: true)
        }
    }
}

struct RequestView: View {
    @StateObject var mxManager: MXManager
    @StateObject var mapManager: MapManager
    @State var address = ""
    var body: some View {
        ZStack{
            Color(mxManager.backgroundColor)
                .ignoresSafeArea(.all)
            VStack{
                MapView(userLocation: mapManager.userLocation, mapManager: mapManager)
                    .background(mxManager.backgroundColor)
                    .ignoresSafeArea(.all)

                if let addy = mapManager.curAddress{
                    TextField(address, text: $address)
                        .onAppear(){
                            address = addy
                        }
                        .onChange(of: address, {
                            mapManager.curAddress = address
                        })
                        .padding()
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 4)
                            .foregroundColor(.black)
                            .frame(minHeight: 30)
                        ).foregroundStyle(Color.white)
                            .padding(20)
                }
                Button(action:{
                    mxManager.signedInScreen = false
                    mxManager.requestScreen = true
                    
                    if address != mapManager.curAddress || !address.isEmpty{
                        mapManager.curAddress = address
                        mxManager.curUser.curAddress = address
                    }
                })
                {
                    Text("Get Me a Mechanic")
                        .padding()
                        .foregroundStyle(Color.white)
                }.background(
                    RoundedRectangle(cornerRadius: 15))
                .foregroundColor(mxManager.buttonColor)
                
            }
            .onAppear(){
                mapManager.getLocation()
                mapManager.getAddress()
                if let addy = mapManager.curAddress
                {
                    address = addy
                }
                else
                {
                    address = ""
                }
            }
        }
    }
}

#Preview {
    RequestView(mxManager: MXManager(), mapManager: MapManager())
}
