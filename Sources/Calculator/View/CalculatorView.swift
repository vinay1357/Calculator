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
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    public init(viewModel: CalculatorViewModel = CalculatorViewModel(screenViewModel: CALCScreenViewModel(screenText: "0", style: CALCScreenViewStyle())), orientation: UIDeviceOrientation =  UIDevice.current.orientation) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            VStack {
                HStack {
                    ScreenView(viewModel: viewModel.screenViewModel)
                }
                .frame(height: 100)
                .padding(.all, 10)
                if verticalSizeClass == .regular && horizontalSizeClass == .compact  {
                    portraitView()
                } else {
                    landscapeView()
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .ignoresSafeArea(.all)
        .toast(data: $viewModel.toastVM)
    }
    
    func landscapeView() -> some View {
        VStack {
            HStack(spacing: 12) {
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
            .fixedSize()
            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
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
        .fixedSize()
        .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        .padding(.bottom, 10)
        
    }
    
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView( orientation: UIDeviceOrientation.portrait)
    }
}

