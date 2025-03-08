//
//  ContentView.swift
//  Finance_Calculator
//
//  Created by user271429 on 3/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Finance Calculator")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .padding(.bottom, 100)
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        NavigationLink(destination: CompoundSavingsView()) {
                            Image("money")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                        NavigationLink(destination: SavingsView()) {
                            Image("money-pig")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                    }
                    HStack(spacing: 20) {
                        NavigationLink(destination: LoansView()) {
                            Image("money-hand")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                        NavigationLink(destination: MortgageView()) {
                            Image("bank")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// Separate class to handle the logic for Compound Savings Model
class CompoundSavingsModel: ObservableObject {
    // Considering monthly interests added
    @Published var principalAmount: String = ""
    @Published var periods: String = ""
    @Published var interest: String = ""
    @Published var years: String = ""
    @Published var result: Double?
    
    func calcCompoundSavings() {
        // Using guard let statement to safely unwrap these optional values, returns nil if fails
        guard let pA = Double(principalAmount),
              let n = Double(periods),
              let r = Double(interest),
              let t = Double(years) else {
            result = nil
            return
        }
        let rateDecimal = n/100
        
        result = pA*pow(1+(rateDecimal/n), n*t)
    }
    
    
}

struct CompoundSavingsView: View {
    @StateObject private var viewModel = CompoundSavingsModel()
    var body: some View {
        VStack{
            TextField("Principal Amount", text: $viewModel.principalAmount).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Interest Rate", text: $viewModel.interest).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Number of Compounding Periods(PA)", text: $viewModel.periods).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Number of Years", text: $viewModel.years).textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Calculate") {
                   viewModel.calcCompoundSavings()
            }
            
            if let result = viewModel.result {
                            Text("Final Amount: \(String(format: "%.2f", result))")
            }
        }
    }
}

// Separate class to handle the logic for Savings Model
class SavingsModel: ObservableObject {
    
}
    
struct SavingsView: View {
    @StateObject private var viewModel = SavingsModel()
     var body: some View {
         Text("Savings")
             .font(.title)
    }
}

// Separate class to handle the logic for Loans Model
class LoansModel: ObservableObject {
    
}

struct LoansView: View {
    @StateObject private var viewModel = LoansModel()
    var body: some View {
        Text("Loans")
            .font(.title)
    }
}

// Separate class to handle the logic for Mortgage Model
class MortgageModel: ObservableObject {
    
}

struct MortgageView: View {
    @StateObject private var viewModel = MortgageModel()
    var body: some View {
        Text("Mortgage")
            .font(.title)
    }
}

#Preview {
    ContentView()
}
