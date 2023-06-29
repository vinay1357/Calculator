//
//  CalculatorView.swift
//  Assignment_Calculator
//
//  Created by VinayKamra on 27/06/23.
//

import SwiftUI
import CalculatorUIComponent

public struct CalculatorView: View {

    @ObservedObject var viewModel = CalculatorViewModel(screenViewModel: CALCScreenViewModel(screenText: "0", style: CALCScreenViewStyle()))
    
    @State var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    public init(viewModel: CalculatorViewModel = CalculatorViewModel(screenViewModel: CALCScreenViewModel(screenText: "0", style: CALCScreenViewStyle())), orientation: UIDeviceOrientation =  UIDevice.current.orientation) {
        self.viewModel = viewModel
        self.orientation = orientation
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            VStack {
                HStack {
                    ScreenView(viewModel: viewModel.screenViewModel)
                }
                .frame(height: 150)
                .padding(.all, 20)
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    landscapeView()
                } else {
                    portraitView()
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
            orientation = UIDevice.current.orientation
        }
        .ignoresSafeArea(.all)
        
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
        .toast(data: $viewModel.toastVM)
    }
    
    func landscapeView() -> some View {
        VStack {
            HStack {
                VStack {
                    ForEach (viewModel.buttons, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(row , id: \.id) { viewModel in
                                CalculatorButtonView(viewModel: viewModel)
                            }
                        }
                        .padding(.bottom, 3)
                    }
                }
                // Right Side Operations
                VStack {
                    ForEach (viewModel.topOperations, id: \.id ) { row in
                        CalculatorButtonView(viewModel: row)
                    }
                    .padding(.bottom, 3)
                }
                
                VStack {
                    ForEach (viewModel.rightOperations, id: \.id ) { row in
                        CalculatorButtonView(viewModel: row)
                            .padding(.bottom, 3)
                    }
                }
            }
            
            
        }
    }
    
    func portraitView() -> some View {
        VStack {
            HStack(spacing: 12) {
                ForEach (viewModel.topOperations, id: \.id ) { row in
                    CalculatorButtonView(viewModel: row)
                        .padding(.bottom, 3)
                }
            }
            
            HStack {
                VStack {
                    ForEach (viewModel.buttons, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(row , id: \.id) { viewModel in
                                CalculatorButtonView(viewModel: viewModel)
                            }
                        }
                        .padding(.bottom, 3)
                    }
                }
                
                VStack {
                    ForEach (viewModel.rightOperations, id: \.id ) { row in
                        CalculatorButtonView(viewModel: row)
                            .padding(.bottom, 3)
                    }
                }
            }
        }
    }
    
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView( orientation: UIDeviceOrientation.portrait)
    }
}

