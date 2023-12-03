//
//  UserViewManager.swift
//  MCHNXRUS
//
//  Created by Gabriel Mannheimer on 12/2/23.
//

import Foundation
import SwiftUI

class UVManager: NSObject, ObservableObject {
    @Published var mxManager: MXManager?
    @Published var ifUserAccount = true
    @Published var ifMessages = false
    @Published var ifSearch = false
    @Published var ifRequest = false
    @Published var ifShop = false
}
