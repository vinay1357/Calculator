//
//  CoinLayerLiveDataRequest.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 28/06/23.
//

import Foundation

enum CoinLayerLiveDataRequest: RequestProtocol {
    case liveData
    
    var path: String {
        "/live"
    }
    
    var requestType: RequestType {
        RequestType.GET
    }
}
