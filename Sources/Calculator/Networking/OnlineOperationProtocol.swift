//
//  OnlineOperationProtocol.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 29/06/23.
//

import Foundation
import CalculatorUIComponent

enum OnlineOperatorError: Error {
    case invalidInput(input: String)
    case bitCoinRatesNotAvailable
    
    
    var description: String {
        switch(self) {
        case let .invalidInput(input):
            return "Invalid Inputs \(input), Only valid number is allowed for online operation."
        case .bitCoinRatesNotAvailable:
            return "Online Rates not avialable for BitCoin"
        }
    }
}

public protocol OnlineOperationProtocol {
    func valueForOperation(inputValue:String, operationType: CalculatorButton) async throws -> Double?
}

public class BitCoinOnlineOperation: OnlineOperationProtocol {
    
    public init() {}
    var netWorkmanager: NetworkApiManagerProtocol = CoinLayerNetworkApiManager()
    
    public func valueForOperation(inputValue: String, operationType: CalculatorUIComponent.CalculatorButton) async throws -> Double? {
        
        guard let value = Double(inputValue) else {
            throw OnlineOperatorError.invalidInput(input: inputValue)
        }
        let manager = CoinLayerNetworkApiManager()
        let response: MarketModel = try await manager.perform(CoinLayerLiveDataRequest.liveData)
        if let rate = response.rates["BTC"] {
            return rate * value
        } else {
            throw OnlineOperatorError.bitCoinRatesNotAvailable
        }        
    }
}
