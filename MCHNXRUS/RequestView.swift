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
                    .padding(30)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .background(mxManager.backgroundColor)
                TextField("", text:
                            $address)
                    .foregroundStyle(Color.white)
                          
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.black)
                    .frame(minHeight: 30)
                ).foregroundStyle(Color.white)
                    .padding(20)
                Button(action:{
                    mxManager.signedInScreen = false
                    mxManager.requestScreen = true
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
                address = mapManager.curAddress ?? ""
            }
        }
    }
}

#Preview {
    RequestView(mxManager: MXManager(), mapManager: MapManager())
}
