//
//  CarDataView.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/14/23.
//

import SwiftUI

struct CarDataView: View {
    @StateObject var mxManager: MXManager
    @State var carMake = ""
    @State var carModel = ""
    @State var carYear = ""
    @State var carVin = ""
    @State var carMilage = ""
    @State var otherDetails = ""
    var body: some View {
        ZStack{
            mxManager.backgroundColor
                .ignoresSafeArea(.all)
            VStack(spacing:20){
                HStack(spacing: 0){
                    Button(action:{
                        mxManager.carInfoScreen = false
                        mxManager.requestScreen = true
                    }){
                        Image(systemName: "arrowshape.backward.circle.fill")
                            .scaleEffect(1.5)
                            .foregroundColor(mxManager.buttonColor)
                            .padding()
                            .offset(x:20)
                        Spacer()
                    }
                    Text("Type: " + mxManager.helpOptions[mxManager.selectedRequest])
                        .foregroundStyle(Color.white)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text("")
                    
                }
                TextField("", text: $carMake, prompt: Text("Enter Car Make")
                    .foregroundStyle(Color(red: 180/255, green: 180/255, blue: 180/255)))
                .padding()
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                        .foregroundColor(.black))
                    .padding(10)
                TextField("", text: $carModel, prompt: Text("Enter Car Model")
                    .foregroundStyle(Color(red: 180/255, green: 180/255, blue: 180/255)))
                .padding()
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                        .foregroundColor(.black))
                .padding(10)
                TextField("", text: $carYear, prompt: Text("Enter Car Year")
                    .foregroundStyle(Color(red: 180/255, green: 180/255, blue: 180/255)))
                .padding()
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                        .foregroundColor(.black))
                .padding(10)
                TextField("", text: $carVin, prompt: Text("Enter Car VIN")
                    .foregroundStyle(Color(red: 180/255, green: 180/255, blue: 180/255)))
                .padding()
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                        .foregroundColor(.black))
                .padding(10)
                TextField("", text: $carMilage, prompt: Text("Enter Car Milage")
                    .foregroundStyle(Color(red: 180/255, green: 180/255, blue: 180/255)))
                .padding()
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                        .foregroundColor(.black))
                .padding(10)
                TextEditor(text: $otherDetails)
                    .padding()
                Button(action:{
                    let curList: [String] = [carMake, carMilage, carModel, carYear, carVin, otherDetails]
                    mxManager.sendRequest(list: curList)
                    mxManager.requestScreen = false
                    mxManager.signedInScreen = true
                }){
                    Text("Submit")
                    .foregroundStyle(Color.white)}
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(mxManager.buttonColor)
                    )
            }
        }
    }
}

#Preview {
    CarDataView(mxManager: MXManager())
}
