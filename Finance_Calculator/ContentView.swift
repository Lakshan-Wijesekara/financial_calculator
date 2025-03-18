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
                    HStack(spacing: 20) {
                        
                        NavigationLink(destination: helpView()) {
                            Image("help")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
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
        guard let P = Double(principalAmount),
              let CpY = Double(periods),
              let r = Double(interest),
              let t = Double(years)
        else {
            result = nil
            return
             }
        let rateDecimal = r/100
        
        result = P*pow(1+(rateDecimal/CpY), CpY*t)
    }
    
    
}

struct CompoundSavingsView: View {
    @StateObject private var viewModel = CompoundSavingsModel()
    var body: some View {
        VStack{
            TextField("Principal Amount", text: $viewModel.principalAmount).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Interest Rate", text: $viewModel.interest).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Number of Compounding Periods (PA)", text: $viewModel.periods).textFieldStyle(RoundedBorderTextFieldStyle())
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
    @Published var principalAmount: String = ""
    @Published var payment: String = ""
    @Published var interestRate: String = ""
    @Published var interestCompoundTimes: String = ""
    @Published var years: String = ""
    @Published var result: Double?
    
    func calcCompoundInterest() {
        // Using guard let statement to safely unwrap these optional values, returns nil if fails
        guard let P = Double(principalAmount),
              let PMT = Double(payment),
              let r = Double(interestRate),
              let CpY = Double(interestCompoundTimes),
              let t = Double(years)
        else {
            result = nil
            return
        }
        let compoundFactor = 1 + (r/100/CpY)
        let exponent = CpY * t
        // Principal future value calculation
        let principalFutureValue = P * pow(compoundFactor, exponent)
        // Regular contribution calculation
        let regularContribution = PMT * ((pow(compoundFactor, exponent)-1) / (r/CpY))
        result = principalFutureValue + regularContribution
    }
    }
    
    struct SavingsView: View {
        @StateObject private var viewModel = SavingsModel()
        var body: some View {
            VStack{
                TextField("Principal Amount", text: $viewModel.principalAmount).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Monthly Payment", text: $viewModel.payment).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Interest Rate (PA)", text: $viewModel.interestRate).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Compounds per Year", text: $viewModel.interestCompoundTimes).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Number of Years", text: $viewModel.years).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Calculate") {
                       viewModel.calcCompoundInterest()
                }
                
                if let result = viewModel.result {
                                Text("Final Amount: \(String(format: "%.2f", result))")
                }
            }
        }
    }
    
    // Separate class to handle the logic for Loans Model
    class LoansModel: ObservableObject {
        @Published var monthlyPayment: Double?
        @Published var repaymentPeriod: Double?
        @Published var principal: String = ""
        @Published var interestRate: String = ""
        @Published var totalPayments: String = ""
        @Published var periodicPayment: String = ""
        @Published var errorMessage: String?
        
        // Method to calculate the monthly payment
        func calcMonthlyPayment() {
            // Using guard let statement to safely unwrap these optional values, returns nil if fails
            guard let P = Double(principal), P > 0,
                  let r = Double(interestRate), r >= 0,
                  let tP = Double(totalPayments), tP > 0
            else {
                monthlyPayment = nil
                errorMessage = "Invalid Input!"
                return
            }
            monthlyPayment = (P * r/(100*12) * pow((1+r/(100*12)), tP)) / (pow((1+r/(100*12)), tP) - 1)
        }
        
        // Method to calculate the rapayment time
        func calcRepaymentTime() {
            guard let P = Double(principal),
                  let r = Double(interestRate),
                  let A = Double(periodicPayment)
            else {
                repaymentPeriod = nil
                errorMessage = "Invalid input!"
                return
            }
            repaymentPeriod = log(A / (A - P * (r / 1200))) / log(1 + (r / 1200))
        }
        
    }
    
struct LoansView: View {
    @StateObject private var viewModel = LoansModel()

    var body: some View {
        VStack(spacing: 20) {
            // Monthly Payment Section
            TextField("Principal Amount", text: $viewModel.principal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            TextField("Interest Rate (PA)", text: $viewModel.interestRate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            TextField("Number of Payments", text: $viewModel.totalPayments)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            Button("Calculate Monthly Payment") {
                viewModel.calcMonthlyPayment()
            }

            if let result = viewModel.monthlyPayment {
                Text("Monthly Payment: \(String(format: "%.2f", result))")
            }

            // Repayment Period Section
            TextField("Periodic Payment", text: $viewModel.periodicPayment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            Button("Calculate Repayment Time") {
                viewModel.calcRepaymentTime()
            }

            if let result = viewModel.repaymentPeriod {
                Text("Repayment Period (months): \(String(format: "%.2f", result))")
            }

            // If error
            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .padding()
    }
}
    
    // Separate class to handle the logic for Mortgage Model
    class MortgageModel: ObservableObject {
        @Published var monthlyMortgagePayment: Double?
        @Published var principal: String = ""
        @Published var annualInterestRate: String = ""
        @Published var totalPayments: String = ""
        @Published var errorMessage: String?
        
        // Method to calculate the monthly payment
        func calcMonthlyMortgagePayment() {
            // Using guard let statement to safely unwrap these optional values, returns nil if fails
            guard let P = Double(principal), P > 0,
                  let r = Double(annualInterestRate), r >= 0,
                  let tP = Double(totalPayments), tP > 0
            else {
                monthlyMortgagePayment = nil
                errorMessage = "Invalid Input!"
                return
            }
            monthlyMortgagePayment = (P * r/(100*12) * pow((1+r/(100*12)), tP)) / (pow((1+r/(100*12)), tP) - 1)
        }
        
        
    }
    
    struct MortgageView: View {
        @StateObject private var viewModel = MortgageModel()
        var body: some View {
            VStack(spacing: 20) {
                // Monthly Mortgage Payment
                TextField("Principal Amount", text: $viewModel.principal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                TextField("Interest Rate (PA)", text: $viewModel.annualInterestRate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                TextField("Number of Payments", text: $viewModel.totalPayments)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                Button("Calculate Monthly Payment") {
                    viewModel.calcMonthlyMortgagePayment()
                }

                if let result = viewModel.monthlyMortgagePayment {
                    Text("Monthly Mortgage Payment: \(String(format: "%.2f", result))")
                }

                // If error
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
            }
        }
    }

// Separate class to handle the logic for Compound Savings Model
class helpModel: ObservableObject {
    
}

struct helpView: View {
    @StateObject private var viewModel = helpModel()
    var body: some View {
        VStack{
            Text("Help Centre")
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .padding(.top, 30)
                .padding(.bottom, 100)
            
            Spacer()
            
            
        }
    }
}
    
    #Preview {
        ContentView()
    }
