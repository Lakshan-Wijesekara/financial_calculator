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
                        
                        NavigationLink(destination: HelpView()) {
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
struct CompoundSavingsView: View {
    @State private var principalAmount: String = "" // Present Value (P)
    @State private var periodsPerYear: String = "" // CpY
    @State private var years: String = "" // t
    @State private var futureValue: String = "" // Future Value (A)
    @State private var interestRate: String = "" // r (in percentage)
    @State private var result: Double? = nil
    @State private var calculationType = "Future Value"
    
    let calculationOptions = ["Future Value", "Interest Rate", "Principal", "Years"]
    
    var body: some View {
        VStack {
            Picker("Calculate", selection: $calculationType) {
                ForEach(calculationOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            TextField("Principal Amount", text: $principalAmount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .disabled(calculationType == "Principal")
            TextField("Number of Compounding Periods (PA)", text: $periodsPerYear)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            TextField("Number of Years", text: $years)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .disabled(calculationType == "Years")
            TextField("Future Value", text: $futureValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .disabled(calculationType == "Future Value")
            TextField("Interest Rate (%)", text: $interestRate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .disabled(calculationType == "Interest Rate")
            
            Button("Calculate") {
                calculate()
            }
            .padding()
            
            if let result = result {
                Text("\(calculationType): \(String(format: "%.2f", result))" + (calculationType == "Interest Rate" ? "%" : ""))
                    .font(.headline)
            } else {
                Text("Please enter valid inputs")
                    .foregroundColor(.red)
            }
        }
    }
    
    private func calculate() {
        // Reset the result
        result = nil
        
        // Convert inputs to Doubles, but only require the ones needed for each case
        let P = Double(principalAmount) ?? 0
        let CpY = Double(periodsPerYear) ?? 0
        let t = Double(years) ?? 0
        let FV = Double(futureValue) ?? 0
        let r = Double(interestRate) ?? 0
        
        switch calculationType {
        case "Future Value":
            // Takes P, CpY, t, r
            guard P > 0, CpY > 0, t > 0, r > 0 else { return }
            let compoundFactor = 1 + (r / 100 / CpY)
            result = P * pow(compoundFactor, CpY * t)
            
        case "Interest Rate":
            // Takes FV, P, CpY, t
            guard FV > 0, P > 0, CpY > 0, t > 0 else { return }
            let base = FV / P
            let exponent = 1 / (CpY * t)
            let rateDecimal = pow(base, exponent) - 1
            result = 100 * CpY * rateDecimal
            
        case "Principal":
            // Takes FV, CpY, t, r
            guard FV > 0, CpY > 0, t > 0, r > 0 else { return }
            let compoundFactor = 1 + (r / 100 / CpY)
            result = FV / pow(compoundFactor, CpY * t)
            
        case "Years":
            // Takes FV, P, CpY, r
            guard FV > 0, P > 0, CpY > 0, r > 0 else { return }
            let compoundFactor = 1 + (r / 100 / CpY)
            result = log(FV / P) / (CpY * log(compoundFactor))
            
        default:
            return
        }
        
        // Ensure result is valid
        if let res = result, !res.isFinite || res < 0 {
            result = nil
        }
    }
}

// Separate class to handle the logic for Savings Model
struct SavingsView: View {
    @State private var principal: String = ""   // P
    @State private var payment: String = ""    // PMT
    @State private var rate: String = ""       // r (%)
    @State private var compounds: String = ""  // CpY
    @State private var years: String = ""      // t
    @State private var future: String = ""     // FV
    @State private var result: Double? = nil
    @State private var calcType = "Future Value"
    
    // Ignored the interest rate calculation because it was hard to isolate the r in the formula
    private let userOptions = ["Future Value", "Principal", "Payment", "Years"]
    
    var body: some View {
        VStack(spacing: 10) {
            Picker("Calculate", selection: $calcType) {
                ForEach(userOptions, id: \.self, content: Text.init)
            }
            .pickerStyle(.segmented)
            
            Group {
                TextField("Principal", text: $principal)
                    .disabled(calcType == "Principal")
                TextField("Monthly Payment", text: $payment)
                    .disabled(calcType == "Payment")
                TextField("Rate (%)", text: $rate)
                TextField("Compounds per Year", text: $compounds)
                TextField("Years", text: $years)
                    .disabled(calcType == "Years")
                TextField("Future Value", text: $future)
                    .disabled(calcType == "Future Value")
            }
            .textFieldStyle(.roundedBorder)
            .keyboardType(.decimalPad)
            .submitLabel(.done) // Adds a "Done" key to dismiss keyboard
            
            Button("Calculate", action: calculate)
                .padding(.top)
            
            if let result = result {
                Text("\(calcType): \(result, specifier: "%.2f")")
                    .font(.headline)
            } else {
                Text("Enter valid inputs")
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
    
    private func calculate() {
        result = nil
        
        let P = Double(principal) ?? 0
        let PMT = Double(payment) ?? 0
        let r = Double(rate) ?? 0
        let CpY = Double(compounds) ?? 0
        let t = Double(years) ?? 0
        let FV = Double(future) ?? 0
        
        switch calcType {
        case "Future Value":
            guard P >= 0, PMT >= 0, r > 0, CpY > 0, t > 0 else { return }
            let compoundFactor = 1 + (r / 100 / CpY)
            let n = CpY * t
            let principalFV = P * pow(compoundFactor, n)
            let regularContrib = PMT * (pow(compoundFactor, n) - 1) / (r / 100 / CpY)
            result = principalFV + regularContrib
            
        case "Principal":
            guard FV > 0, PMT >= 0, r > 0, CpY > 0, t > 0 else { return }
            let compoundFactor = 1 + (r / 100 / CpY)
            let n = CpY * t
            let regularContrib = PMT * (pow(compoundFactor, n) - 1) / (r / 100 / CpY)
            result = (FV - regularContrib) / pow(compoundFactor, n)
            
        case "Payment":
            guard FV > 0, P >= 0, r > 0, CpY > 0, t > 0 else { return }
            let compoundFactor = 1 + (r / 100 / CpY)
            let n = CpY * t
            let principalFV = P * pow(compoundFactor, n)
            result = (FV - principalFV) * (r / 100 / CpY) / (pow(compoundFactor, n) - 1)
            
        case "Years":
            guard FV > 0, P >= 0, PMT >= 0, r > 0, CpY > 0 else { return }
            let compoundFactor = 1 + (r / 100 / CpY)
            let numerator = log((FV * (r / 100 / CpY) + PMT) / (P * (r / 100 / CpY) + PMT))
            let denominator = CpY * log(compoundFactor)
            result = numerator / denominator
            
        default:
            return
        }
        
        if let res = result, !res.isFinite || res < 0 { result = nil }
    }
}

// Separate view to handle the logic for Loans Model
struct LoansView: View {
    @State private var principal: String = ""    // P
    @State private var payment: String = ""     // PMT
    @State private var rate: String = ""        // r (%)
    @State private var payments: String = ""    // n (total payments)
    @State private var result: Double? = nil
    @State private var calcType = "Payment"     // Default
    @State private var errorMessage: String? = nil
    
    // Ignored Interest Rate calculation here since the calculation is complex considering the formula
    private let userOptions = ["Payment", "Principal", "Payments"]
    
    var body: some View {
        VStack(spacing: 10) {
            Picker("Calculate", selection: $calcType) {
                ForEach(userOptions, id: \.self, content: Text.init)
            }
            .pickerStyle(.segmented)
            // To reset the textfields when going into another option
            .onChange(of: calcType) { _ in
                principal = ""
                payment = ""
                rate = ""
                payments = ""
                result = nil
                errorMessage = nil
            }
            
            Group {
                TextField("Principal", text: $principal)
                    .disabled(calcType == "Principal")
                TextField("Monthly Payment", text: $payment)
                    .disabled(calcType == "Payment")
                TextField("Rate (%)", text: $rate)
                TextField("Total Payments", text: $payments)
                    .disabled(calcType == "Payments")
            }
            .textFieldStyle(.roundedBorder)
            .keyboardType(.decimalPad)
            
            Button("Calculate", action: calculate)
                .padding(.top)
            
            if let result = result {
                Text("\(calcType): \(result, specifier: "%.2f")")
                    .font(.headline)
            }
            
            if let error = errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
    
    private func calculate() {
        result = nil
        errorMessage = nil
        
        let P = Double(principal) ?? 0
        let PMT = Double(payment) ?? 0
        let r = Double(rate) ?? 0
        let n = Double(payments) ?? 0
        let CpY = 12.0 // Considered this as 12, since an year has 12 payments
        
        switch calcType {
        case "Payment": // PMT
            guard P > 0, r > 0, n > 0 else {
                errorMessage = "Invalid input!"
                return
            }
            let monthlyRate = r / (100 * CpY)
            let compoundFactor = pow(1 + monthlyRate, n)
            result = (P * monthlyRate * compoundFactor) / (compoundFactor - 1)
            
        case "Principal": // P
            guard PMT > 0, r > 0, n > 0 else {
                errorMessage = "Invalid input!"
                return
            }
            let monthlyRate = r / (100 * CpY)
            let compoundFactor = pow(1 + monthlyRate, n)
            result = PMT * (compoundFactor - 1) / (monthlyRate * compoundFactor)
            
        case "Payments": // n
            guard P > 0, PMT > 0, r > 0, PMT > P * (r / (100 * CpY)) else {
                errorMessage = "Invalid input!"
                return
            }
            let monthlyRate = r / (100 * CpY)
            result = log(PMT / (PMT - P * monthlyRate)) / log(1 + monthlyRate)
            
        default:
            return
        }
        
        if let res = result, !res.isFinite || res < 0 {
            result = nil
            errorMessage = "Result invalid!"
        }
    }
}
    
    // Separate class to handle the logic for Mortgage Model
struct MortgageView: View {
    @State private var principal: String = ""    // P
    @State private var payment: String = ""     // PMT
    @State private var rate: String = ""        // r (%)
    @State private var payments: String = ""    // n (total payments)
    @State private var result: Double? = nil
    @State private var calcType = "Payment"     // Default
    @State private var errorMessage: String? = nil
    
    private let options = ["Payment", "Principal", "Payments"]
    
    var body: some View {
        VStack(spacing: 10) {
            Picker("Calculate", selection: $calcType) {
                ForEach(options, id: \.self, content: Text.init)
            }
            .pickerStyle(.segmented)
            .onChange(of: calcType) { _ in
                // Reset all fields when calcType changes
                principal = ""
                payment = ""
                rate = ""
                payments = ""
                result = nil
                errorMessage = nil
            }
            
            Group {
                TextField("Principal", text: $principal)
                    .disabled(calcType == "Principal")
                TextField("Monthly Payment", text: $payment)
                    .disabled(calcType == "Payment")
                TextField("Rate (%)", text: $rate)
                TextField("Total Payments", text: $payments)
                    .disabled(calcType == "Payments")
            }
            .textFieldStyle(.roundedBorder)
            .keyboardType(.decimalPad)
            .submitLabel(.done)
            
            Button("Calculate", action: calculate)
                .padding(.top)
            
            if let result = result {
                Text("\(calcType): \(result, specifier: "%.2f")")
                    .font(.headline)
            }
            
            if let error = errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
    
    private func calculate() {
        result = nil
        errorMessage = nil
        
        let P = Double(principal) ?? 0
        let PMT = Double(payment) ?? 0
        let r = Double(rate) ?? 0
        let n = Double(payments) ?? 0
        let CpY = 12.0 // Monthly compounding
        
        switch calcType {
        case "Payment": // PMT
            guard P > 0, r > 0, n > 0 else {
                errorMessage = "Invalid input!"
                return
            }
            let monthlyRate = r / (100 * CpY)
            let compoundFactor = pow(1 + monthlyRate, n)
            result = (P * monthlyRate * compoundFactor) / (compoundFactor - 1)
            
        case "Principal": // P
            guard PMT > 0, r > 0, n > 0 else {
                errorMessage = "Invalid input!"
                return
            }
            let monthlyRate = r / (100 * CpY)
            let compoundFactor = pow(1 + monthlyRate, n)
            result = PMT * (compoundFactor - 1) / (monthlyRate * compoundFactor)
            
        case "Payments": // n
            guard P > 0, PMT > 0, r > 0, PMT > P * (r / (100 * CpY)) else {
                errorMessage = "Invalid input!"
                return
            }
            let monthlyRate = r / (100 * CpY)
            result = log(PMT / (PMT - P * monthlyRate)) / log(1 + monthlyRate)
            
        default:
            return
        }
        
        if let res = result, !res.isFinite || res < 0 {
            result = nil
            errorMessage = "Result invalid!"
        }
    }
}

// Separate class to handle the logic for Compound Savings Model
struct HelpView: View {
    // Static array of help points
    private let helpPoints = [
        "The financial calculator is an all-in-one application for all your savings, compound interest, loan calculations, and mortgage payment calculations.",
        "Each of the four icons represents a calculation page, and you can navigate by clicking the relevant icon.",
        "The first icon on the top left takes the user to the Compound Interest Savings Calculator.",
        "The second icon on the top right takes the user to the Savings Calculator.",
        "The third icon on the bottom left takes the user to the Loan Calculator.",
        "The fourth icon on the bottom right takes the user to the Mortgage Payment Calculator.",
        "From each calculator, user can select to calculate several types of parameters.",
        "Namely, Interest Rate, Final Value, Present Value, Estimated Payment and Number of Payments."
    ]
    
    var body: some View {
        VStack {
            Text("Help Centre")
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .padding(.top, 30)
                .padding(.bottom, 50)
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(helpPoints, id: \.self) { point in
                    HStack(alignment: .firstTextBaseline) {
                        //Use firstTextBaseline to keep the bullets at the start of a sentence
                        Text("•") // For Using a bullet point
                            .font(.system(size: 20))
                        Text(point)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
    
    #Preview {
        ContentView()
    }
