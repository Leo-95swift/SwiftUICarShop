//
//  CarShopViewModel.swift
//  SwiftUICarShop
//
//  Created by Levon Shaxbazyan on 02.05.24.
//

import Foundation

/// Класс для бизнес логики приложения
final class CarShopViewModel: ObservableObject {
    
    // MARK: - Constants

    private enum Constants {
        static let firstCar = "car_C5"
        static let secondCar = "car_S5"
        static let thirdCar = "car_S5_GT"
    }
    
    // MARK: - Published Properties
    
    @Published public var segmentIndex = 0
    @Published public var sliderValue: Double = 0
    @Published public var insurancePrice = 0
    @Published public var carPrice = 1659000
    @Published public var totalPrice = 1659000

    // MARK: - Private Properties
    
    private var carEquipmentPrice = 190000
    private var extraPrice = 0
    private var currentInsurePrice = 0
    private var currentSliderValue = 0
    private var sliderMove = 0
    private var currentInsurance: InsureToggle = .isOff
    
    public var carModels: [Car] = [
        Car(carModel: "C5", carImageName: "car_C5", price: 1659000),
        Car(carModel: "S5", carImageName: "car_S5", price: 1820000),
        Car(carModel: "S5 GT", carImageName: "car_S5_GT", price: 2159000)]
    
    // MARK: - Private Methodes

    private func updateTotalPrice() {
        totalPrice = carPrice + extraPrice + currentInsurePrice
    }
    
    // MARK: - Public Methodes

    public func updateSLiderMove(newValue: Int) -> Int {
        sliderMove = newValue - currentSliderValue
        print("sm \(sliderMove)")
        currentSliderValue = newValue
        return sliderMove
    }
    
    public func updateSegmentControl(newIndex: Int) {
        carPrice = carModels[newIndex].price
    }
    
    public func updateInsurePrice() {
        switch currentInsurance {
        case .isOn:
            currentInsurePrice = 0
            currentInsurance = .isOff
        case .isOff:
            currentInsurePrice = 99000
            currentInsurance = .isOn
        }
    }
    
    public func updateTotalPrice(change: PriceChange) {
        switch change {
        case .segment:
            updateSegmentControl(newIndex: segmentIndex)
        case .slider:
            let value = updateSLiderMove(newValue: Int(sliderValue))
            extraPrice += Int(value) * carEquipmentPrice
        case .toggle:
            updateInsurePrice()
        }
        updateTotalPrice()
        
    }
    
    public func formatToString(number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        if let formattedString = formatter.string(from: NSNumber(value: number)) {
            return formattedString
        }
        return ""
    }
    
}
