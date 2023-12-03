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
    
}

class MXManager: NSObject, ObservableObject {
    @Published var helpOptions = ["Suspensions", "Brakes", "Engine", "Chassi", "Interior", "Lights", "Electronics","Audio"]
    @Published var loginScreen = true
    @Published var signedInScreen = false
    @Published var signUpScreen = false
    @Published var database = Firestore.firestore()
    @Published var curUser = MyUser()
    @Published var backgroundColor = Color(red: 35/255, green: 42/255, blue: 47/255)
    @Published var buttonColor = Color(red: 240/255, green: 100/255, blue: 75/255)
    @Published var isInFirebase = false

    
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
                    
                        self.curUser.email = firebaseUser.email ?? ""
                        self.curUser.phoneNumber = firebaseUser.phoneNumber ?? ""

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
            Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
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
                "email": user.email ?? "",
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
                "email": email,
                "phoneNumber": phoneNumber,
                "userType": userType
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
        do{
            let querySnapshot = try await userCollection.whereField("email", isEqualTo: email).getDocuments()
            
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
        userCollection.whereField("email", isEqualTo: email).getDocuments{ (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            if let snapshot = snapshot{
                for document in snapshot.documents {
                    let data = document.data()
                    if let phoneNumber = data["phoneNumber"] as? String {
                                    // Use the phoneNumber
                        self.curUser.phoneNumber = phoneNumber
                                } else {
                                    print("Phone number not found or nil")
                                }
                }
            }
        }
    }
    
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){ authUser, error in
            if let error = error{
                print("Error with sign in: \(error.localizedDescription)")
            }
            if let authUser = authUser{
                self.loginScreen = false
                self.signedInScreen = true
                self.curUser.email = authUser.user.email?.description ?? ""
                //print("inside sign in: \(authUser.user.email?.description ?? "no email from auth")")
                //print("curUser email: \(self.curUser.email?.description)")
                if let email = self.curUser.email{
                    self.getPhoneNumber(email: email)
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
        
    }

}

