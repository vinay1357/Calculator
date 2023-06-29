//
//  CalculatorViewModel.swift
//  Assignment_Calculator
//
//  Created by VinayKamra on 27/06/23.
//

import Foundation
import SwiftUI
import ThemeKit
import CalculatorUIComponent

enum ConversionError: Error {
    case NotANumber
}

public final class CalculatorViewModel: ObservableObject {
    
    let featureFlags: CalculatorFeatureFlags
    @Published var buttons: [[CALCButtonViewModel]] = [[]]
    @Published var topOperations: [CALCButtonViewModel] = []
    @Published var rightOperations: [CALCButtonViewModel] = []
    @Published var toastVM: CALCBannerViewModel?
    @Published var screenViewModel: CALCScreenViewModel
    
    var lastOperation: CalculatorButton = .none
    var subTotal: Double = 0.0
    let regularExpressionParser: CalculatorParserProtocol
    let reachability: NetworkReachability = NetworkReachability.shared
    let onlineOperationManager: OnlineOperationProtocol
    var screenText: String {
        set {
            self.screenViewModel.screenText = newValue
        }
        get {
            self.screenViewModel.screenText
        }
    }
    
    public init(featureFlags: CalculatorFeatureFlags = CalculatorFeatureFlags.featureFlags,
         regularExpressionParser: CalculatorParserProtocol = RegularExpressionParser(),
         onlineOperationManager: OnlineOperationProtocol = BitCoinOnlineOperation(),
         screenViewModel:CALCScreenViewModel ) {
        self.featureFlags = featureFlags
        self.regularExpressionParser = regularExpressionParser
        self.screenViewModel = screenViewModel
        self.onlineOperationManager = onlineOperationManager
    }
    
    func allowedOperations() -> [CALCButtonViewModel] {
        
        var allowedOperations: [CALCButtonViewModel] = []
        
        if self.featureFlags.calculator.showOnlineOperator {
            allowedOperations.append(
                .init(style:
                        CALCButtonTypeStyle(buttonStyle: .operation,
                                            backgroundColor: Theme.currentTheme.operationBackgroundColor,
                                            foregroundColor: Theme.currentTheme.operationFontColor),
                      type: .online,
                      handleButtonTapAction: handleTabActionButton))
        }
        
        if self.featureFlags.calculator.showCosOperator {
            allowedOperations.append(
                .init(style:
                        CALCButtonTypeStyle(buttonStyle: .operation,
                                            backgroundColor: Theme.currentTheme.operationBackgroundColor,
                                            foregroundColor: Theme.currentTheme.operationFontColor),
                      type: .cos, handleButtonTapAction: handleTabActionButton))
        }
        
        if self.featureFlags.calculator.showSinOperator {
            allowedOperations.append(
                .init(style:
                        CALCButtonTypeStyle(buttonStyle: .operation,
                                            backgroundColor: Theme.currentTheme.operationBackgroundColor,
                                            foregroundColor: Theme.currentTheme.operationFontColor),
                      type: .sin, handleButtonTapAction: handleTabActionButton))
        }
        
        if self.featureFlags.calculator.showDivisionOperator {
            allowedOperations.append(
                .init(style:
                        CALCButtonTypeStyle(buttonStyle: .operation,
                                            backgroundColor: Theme.currentTheme.operationBackgroundColor,
                                            foregroundColor: Theme.currentTheme.operationFontColor),
                      type: .divide, handleButtonTapAction: handleTabActionButton))
        }
        
        if self.featureFlags.calculator.showMultiplyOperator {
            allowedOperations.append(
                .init(style:
                        CALCButtonTypeStyle(buttonStyle: .operation,
                                            backgroundColor: Theme.currentTheme.operationBackgroundColor,
                                            foregroundColor: Theme.currentTheme.operationFontColor),
                      type: .multiply, handleButtonTapAction: handleTabActionButton))
        }
        
        if self.featureFlags.calculator.showMinusOperator {
            allowedOperations.append(
                .init(style:
                        CALCButtonTypeStyle(buttonStyle: .operation,
                                            backgroundColor: Theme.currentTheme.operationBackgroundColor,
                                            foregroundColor: Theme.currentTheme.operationFontColor),
                      type: .subtract, handleButtonTapAction: handleTabActionButton))
        }
        
        if self.featureFlags.calculator.showPlusOperatorr {
            allowedOperations.append(
                .init(style:
                        CALCButtonTypeStyle(buttonStyle: .operation,
                                            backgroundColor: Theme.currentTheme.operationBackgroundColor,
                                            foregroundColor: Theme.currentTheme.operationFontColor),
                      type: .sum, handleButtonTapAction: handleTabActionButton))
        }
        allowedOperations.append(
            .init(style:
                    CALCButtonTypeStyle(buttonStyle: .operation,
                                        backgroundColor: Theme.currentTheme.operationBackgroundColor,
                                        foregroundColor: Theme.currentTheme.operationFontColor),
                  type: .result, handleButtonTapAction: handleTabActionButton))
        return allowedOperations
    }
    
    func onAppear() {
        
        self.startNetworkMonitoring()
        
        let allowedOperations = self.allowedOperations()
        
        if allowedOperations.count > 4 {
            topOperations = Array(allowedOperations[..<4])
            
            rightOperations = Array(allowedOperations[4..<allowedOperations.count])
        } else {
            rightOperations = allowedOperations
        }
        buttons = getNumbersButton()
    }
    
    func getNumbersButton() -> [[CALCButtonViewModel]] {
        
        let style = CALCButtonTypeStyle(buttonStyle: .numbers)
        
        let numbersSequence2D: [[CalculatorButton]] = [[.seven, .eight, .nine ],
                                                       [.four, .five, .six],
                                                       [.one, .two, .three],
                                                       [.clearText, .zero, .dot]]
        
        let numberButtons: [[CALCButtonViewModel]] = numbersSequence2D.map { numbers in
            return numbers.map { value in
                return CALCButtonViewModel(style: style, type: value, handleButtonTapAction: handleTabActionButton)
            }
        }
        return numberButtons
    }
    
    func parseRegularExpression() {
        do {
            let result = try self.regularExpressionParser.parseString(rawValue: self.screenText)
            self.screenText = result.clean
        } catch {
            self.screenText = "Invalid Number Or Result"
            lastOperation = .none
        }
    }
    
    func onlineOperation(input: String, type: CalculatorButton) {
        Task {
            do {
                guard let value = try await self.onlineOperationManager.valueForOperation(inputValue:input , operationType: type) else {
                    return
                }
                
                await MainActor.run {
                    self.screenText = value.clean
                }
                
            }
            catch let e as NetworkError {
                switch e {
                case .connectivityError:
                    await MainActor.run {
                        toastVM = .init(title: "This functionality only available online , please check your network or try again after some time", type: .error)
                        self.screenText = "0"
                        lastOperation = .none
                    }
                    
                    
                default: break
                }
                
            }
            catch let e as OnlineOperatorError{
                await MainActor.run {
                    toastVM = .init(title: e.description, type: .error)
                    self.screenText = "Invalid Input / Result"
                    lastOperation = .none
                }
            }
            catch {
                print(error)
            }
        }
        
    }
    
    func handleTabActionButton(viewModel: CALCButtonViewModel)  {
        if viewModel.type == .online {
            onlineOperation(input: self.screenText, type: viewModel.type)
        }
        else if viewModel.type == .clearText {
            self.screenText = "0"
            self.lastOperation = .none
        } else if viewModel.type == .result {
            parseRegularExpression()
        } else if viewModel.type == .sin || viewModel.type == .cos {
            do {
                let value = try CalculatorOperationUtility.getTrigoValueforButtonType(buttonType: viewModel.type,
                                                                                      rawValue: self.screenText)
                self.screenText = String(value ?? 0.0)
                
            } catch {
                self.screenText = "Invalid Number/ Result"
                lastOperation = .none
            }
        }
        else {
            print(viewModel.type.rawValue)
            if viewModel.style.buttonStyle == .operation && lastOperation.style == .operation {
                self.screenText.removeLast()
                self.screenText += viewModel.title
            }
            else if viewModel.style.buttonStyle != .operation && (lastOperation == .result || lastOperation == .none) {
                self.screenText = viewModel.type.rawValue
            } else {
                if screenText != "0" {
                    self.screenText = self.screenText + viewModel.type.rawValue
                } else {
                    self.screenText = viewModel.type.rawValue
                    
                }
            }
            lastOperation = viewModel.type
        }
    }
    
    func startNetworkMonitoring() {
        let nc = NotificationCenter.default
        self.reachability.monitorNetworkChange()
        self.reachability.connectivityStatusPublisher
            .sink { [weak self] connectivityStatus in
                DispatchQueue.main.async {
                    guard let strongSelf = self, connectivityStatus != .unknown else { return }
                    if connectivityStatus == .connected {
                        nc.post(
                            name: Notification.Name("NetworkConnectivityChangedToConnected"),
                            object: nil
                        )
                    } else {
                        nc.post(
                            name: Notification.Name("NetworkConnectivityChangedToNotConnected"),
                            object: nil
                        )
                    }
                }
            }
    }
    
}
