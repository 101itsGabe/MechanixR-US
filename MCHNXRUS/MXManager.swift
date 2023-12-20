//
//  FullAppManager.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 11/25/23.
//

import Foundation
import SwiftUI
import CoreLocation
import FirebaseFirestoreInternal
import FirebaseFirestore
import Firebase
import FirebaseDatabaseInternal
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
//This is going to be the full app manager needed use PostgresSQL for users

struct MyUser{
    var email: String?
    var phoneNumber: String?
    var imageURL: URL?
    var userLocation: CLLocation?
    var userType: Int?
    var curAddress: String?
}

struct MyRequest: Hashable {
    var email: String?
    var curAddress: String?
    var carMake: String?
    var carModel: String?
    var issue: String?
    var timestamp: Timestamp?
    
    func toReadableTime() -> String{
        var readableTime = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm:ss a"
        if let timestamp = timestamp{
            readableTime = dateFormatter.string(from: timestamp.dateValue())
        }
        return readableTime
    }
}

class MXManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var helpOptions = ["Suspensions", "Brakes", "Engine", "Chassi", "Interior", "Lights", "Electronics","Audio", "Tires", "Other"]
    @Published var loginScreen = true
    @Published var signedInScreen = false
    @Published var signUpScreen = false
    @Published var requestScreen = false
    @Published var carInfoScreen = false
    @Published var database = Firestore.firestore()
    @Published var curUser = MyUser()
    @Published var backgroundColor = Color(red: 35/255, green: 42/255, blue: 47/255)
    @Published var buttonColor = Color(red: 240/255, green: 100/255, blue: 75/255)
    @Published var isInFirebase = false
    @Published var isReady = false
    @Published var hasBeenUpdated = false
    @Published var selectedRequest = 0
    
    
    func performGoogleSignin() async -> Bool {
        enum SignInError: Error {
            case idTokenMissing
        }
        let signInConfig = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
        //let signIn = GIDSignIn.sharedInstance
        GIDSignIn.sharedInstance.configuration = signInConfig
        print("After sign In config")
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else{
            print("There is not root view controller")
            return false
        }
        do{
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else{
                throw SignInError.idTokenMissing
            }
            
            let accessToken = user.accessToken
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            do{
                let result = try await Auth.auth().signIn(with: credentials)
                //var firebaseUser: User?
                //print(firebaseUser.email ?? "did not get an email")
                
                let firebaseUser = result.user
                if firebaseUser != nil{
                    //curUser = firebaseUser
                    
                    DispatchQueue.main.async {
                        self.curUser.email = firebaseUser.email ?? ""
                        self.curUser.phoneNumber = firebaseUser.phoneNumber ?? ""
                    }
                    
                    if let photoURL = firebaseUser.photoURL{
                        curUser.imageURL = photoURL
                    }
                    else{
                        print("No PhotoURL")
                    }
                    let userCollection = database.collection("Users")
                    userCollection.getDocuments { snapshot, error in
                        if let error = error {
                            print("Error fetching documents: AHH \(error.localizedDescription)")
                        } else {
                            if snapshot?.isEmpty ?? true {
                                print("The collection 'Users' is empty or does not exist. AHH")
                            } else {
                                // You can perform actions with the documents here
                                userCollection.whereField("email", isEqualTo: self.curUser.email).getDocuments{ (snapshot, error) in
                                    if let error = error{
                                        print(error.localizedDescription)
                                    }
                                    else{
                                        guard let snapshot = snapshot else{
                                            print("Snapshot is null")
                                            return
                                        }
                                        
                                        if snapshot.isEmpty{
                                            self.addUserToDatabase(user: firebaseUser)
                                        }
                                        else{
                                            for document in snapshot.documents {
                                                let data = document.data()
                                                if let phoneNumber = data["phoneNumber"] as? String{
                                                    self.curUser.phoneNumber = phoneNumber
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }// end of if firebase user
            }
            catch{
                print(error.localizedDescription)
            }
            
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    } //end of google sign in
    
    func createNewUser(email: String, password: String, phoneNum: String) async throws{
        do{
            Auth.auth().createUser(withEmail: email.lowercased(), password: password){ authResult, error in
                if let error = error{
                    print("Error inside Auth: \(error.localizedDescription)")
                }
                else if let authResult = authResult{
                    print("Sucessfully in authUser")
                    self.curUser.email = authResult.user.email ?? ""
                    self.curUser.phoneNumber = phoneNum
                    //self.addUserFromSignUp(email: email, phoneNumber: phoneNum)
                }
            }
        }
        catch{
            throw error
        }
    }
    
    
    
    
    
    func addUserToDatabase(user: User){
        let userCollection = database.collection("Users")
        userCollection.getDocuments { snapshot, error in
            userCollection.addDocument(data: [
                "email": user.email?.lowercased() ?? "",
                "phoneNum": user.phoneNumber ?? ""
            ]){ error in
                if let error = error {
                    print(error.localizedDescription + "Error adding user")
                }
            }
        }
    }
    
    func addUserFromSignUp(email: String, phoneNumber: String, userType: Int){
        self.curUser.userType = userType
        let userCollection = database.collection("Users")
        userCollection.getDocuments { snapshot, error in
            userCollection.addDocument(data: [
                "email": email.lowercased(),
                "phoneNumber": phoneNumber,
                "userType": userType,
                "isReady": false
            ]){ error in
                if let error = error {
                    print(error.localizedDescription + "Error adding user")
                }
            }
        }
    }
    
    @MainActor func getUserFromDatabase(email: String) async{
        database = Firestore.firestore()
        let userCollection = database.collection("Users")
        print("GETUSER")
        print("Email in getuser: \(email)")
        do{
            let querySnapshot = try await userCollection.whereField("email", isEqualTo: email.lowercased()).getDocuments()
            
            if !querySnapshot.isEmpty{
                print("User is already in databse")
                for document in querySnapshot.documents{
                    let data = document.data()
                    self.isInFirebase = true
                    print(data["email"].debugDescription)
                    if let emailInside = data["email"] as? String{
                        print(emailInside.description)
                    }
                    
                    print(self.isInFirebase)
                }
                
            }
            else{
                print("GetUser from database USER IS NOT IN")
                DispatchQueue.main.async {
                    // Update UI here
                    self.isInFirebase = false
                    // Or any other UI-related changes
                }
                self.isInFirebase = false
            }
        }
        //Just return the string
        catch{
            print("There was an error")
        }
        
    }
    
    func getPhoneNumber(email: String){
        let userCollection = database.collection("Users")
        userCollection.whereField("email", isEqualTo: email.lowercased()).getDocuments{ (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            if let snapshot = snapshot{
                for document in snapshot.documents {
                    let data = document.data()
                    if let phoneNumber = data["phoneNumber"] as? String {
                        // Use the phoneNumber
                        self.curUser.phoneNumber = phoneNumber
                        print("Phone#: \(phoneNumber)")
                    } else {
                        print("Phone number not found or nil")
                    }
                }
            }
        }
    }
    
    func getUserType(email: String){
        let userCollection = database.collection("Users")
        userCollection.whereField("email", isEqualTo: email.lowercased()).getDocuments{ (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            if let snapshot = snapshot{
                for document in snapshot.documents {
                    let data = document.data()
                    if let userType = data["userType"] as? Int {
                        // Use the phoneNumber
                        self.curUser.userType = userType
                    } else {
                        print("Phone number not found or nil")
                    }
                }
            }
        }
    }
    
    
    func signIn(email: String, password: String){
        
        Auth.auth().signIn(withEmail: email.lowercased(), password: password){ authUser, error in
            if let error = error{
                print("Error with sign in: \(error.localizedDescription)")
            }
            if let authUser = authUser{
                self.loginScreen = false
                self.signedInScreen = true
                self.curUser.email = authUser.user.email?.description ?? ""
                if let email = self.curUser.email{
                    self.getPhoneNumber(email: email)
                    self.getUserType(email: email)
                }
                
                print("signIn Succsefful")
            }
        }
    }
    
    func signOutUser(){
        curUser.email = ""
        curUser.phoneNumber = ""
        curUser.imageURL = nil
        curUser.userLocation = nil
        self.loginScreen = true
        self.signedInScreen = false
        self.signUpScreen = false
        self.isInFirebase = false
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Something went wrong signing out user")
        }
        
    }
    
    func checkUserAuth() async{
        if let currentUser = Auth.auth().currentUser{
            DispatchQueue.main.async {
                self.signedInScreen = true
                self.loginScreen = false
                self.curUser.email = currentUser.email
                self.getPhoneNumber(email: currentUser.email ?? "")
                //curUser.phoneNumber = currentUser.phoneNumber ?? ""
                self.curUser.imageURL = currentUser.photoURL ?? nil
                self.getUserType(email: currentUser.email ?? "none")
            }
        }
        else{
            self.loginScreen = true
            self.signedInScreen = false
        }
    }
    
    //Updates a contractors status
    func updateStatus(){
        database = Firestore.firestore()
        let userCollection = database.collection("Users")
        if let email = curUser.email?.lowercased() {
            userCollection.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                
                if let error = error{
                    print(error.localizedDescription)
                }
                else if let snapshot = querySnapshot{
                    for document in snapshot.documents {
                        if(self.isReady){
                            userCollection.document(document.documentID).updateData(["isReady" : true]){ error in
                                if let error = error{
                                    print(error.localizedDescription)
                                }
                                else{
                                    print("Update was successful")
                                }
                                
                            }
                        }
                        else{
                            userCollection.document(document.documentID).updateData(["isReady" : false]){ error in
                                if let error = error{
                                    print(error.localizedDescription)
                                }
                                else{
                                    print("Update was successful")
                                }
                                
                            }
                        }
                    }
                }
                
            }
        }
        
    }
    
    func getContractors(completion: @escaping ([String]) -> Void){
        database = Firestore.firestore()
        let userCollection = database.collection("Users")
        userCollection.whereField("isReady", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                completion([])
            }
            else if let snapshot = querySnapshot{
                var usersList: [String] = []
                for document in snapshot.documents {
                    if let email = document.data()["email"] as? String {
                        usersList.append(email)
                    }
                }
                
                completion(usersList)
            }
        }
    }

    
    func updateYoSelf(){
        if hasBeenUpdated == false{
            if let email = curUser.email?.lowercased(){
                self.getUserType(email: email)
                self.getPhoneNumber(email: email)
            }
            hasBeenUpdated = true
        }
    }
    
    
    func sendRequest(list: [String]){
        database = Firestore.firestore()
        let requestsCollection = database.collection("Requests")
        requestsCollection.getDocuments { snapshot, error in
            
            if let error = error{
                print(error.localizedDescription)
                print("ERROR IN REQESTS")
            }
            
            requestsCollection.addDocument(data: [
                    "CarMake": list[0],
                    "CarMilage": list[1],
                    "CarModel": list[2],
                    "CarYear": list[3],
                    "CarVIN": list[4],
                    "Explain": list[5],
                    "Category": self.helpOptions[self.selectedRequest],
                    "email": self.curUser.email ?? "",
                    "address": self.curUser.curAddress ?? "",
                    "timestamp": FieldValue.serverTimestamp()
                ])
        }
    }
    
    func getRequests(completion: @escaping ([MyRequest]) -> Void){
        database = Firestore.firestore()
        let userCollection = database.collection("Requests")
        userCollection.getDocuments { (querySnapshot, error) in
            if let error = error{
                print("error in requests")
                print(error.localizedDescription)
                completion([])
            }
            else if let snapshot = querySnapshot{
                print("inside snapshot reqests")
                var requestsList: [MyRequest] = []
                for document in snapshot.documents {
                    print("inside docs")
                    var curRequest = MyRequest()
                    let data = document.data()
                    if data != nil{
                        if let email = data["email"] as? String{
                            curRequest.email = email
                        }
                    }
                    else{
                        print("NIL")
                    }
                    if let email = document.data()["email"] as? String {
                        curRequest.email = email
                    }
                    if let address = document.data()["address"] as? String{
                        curRequest.curAddress = address
                    }
                    if let carMake = document.data()["CarMake"] as? String{
                        curRequest.carMake = carMake
                    }
                    
                    if let carModel = document.data()["CarModel"] as? String{
                        curRequest.carModel = carModel
                    }
                    
                    if let issue = document.data()["Explain"] as? String{
                        curRequest.issue = issue
                    }
                    
                    if let timestamp = document.data()["timestamp"] as? Timestamp{
                        curRequest.timestamp = timestamp
                    }
                    
                    requestsList.append(curRequest)
                }
                
                completion(requestsList)
            }
        }
    }
}

