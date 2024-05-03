//
//  ContentView.swift
//  SwiftUICarShop
//
//  Created by Levon Shaxbazyan on 02.05.24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Constants

    private enum Constants {
        // Buttons
        static let orderButton = "Заказать"
        static let shareButton = "shareButton"
        
        // Labels
        static let joy = "Joy"
        static let lifestyle = "Lifestyle"
        static let ultimate = "Ultimate"
        static let active = "Active"
        static let supreme = "Supreme"
        static let price = "Цена"
        static let toggleLabel = "ОМОДА Каско"
        static let actionSheetText = "Благодарим за заказ. Наш менеджер свяжется с Вами в рабочее время для уточнения деталей"
        
        // Alerts
        static let alertText = "ОМОДА Каско"
        static let alertMessage = "Подключить Каско на выгодных условиях?"
        static let alertPrimaryButton = "Нет, не нужно"
        static let alertSecondaryButton = "Да"
        
    }
    
    @ObservedObject var viewModel = CarShopViewModel()
    
    // MARK: - @State Private Properties

    @State private var offsetX: CGFloat = 0
    @State private var isSharePresented = false
    @State private var isInsuranceIncluded = false
    @State private var isOrderButtonTapped = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.viewBackground
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 32)
                shopLogoView
                Spacer().frame(height: 22)
                carImageView
                Spacer().frame(height: 22)
                segmentView
                Spacer().frame(height: 32)
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .ignoresSafeArea()
                    VStack(spacing: -7) {
                        Spacer().frame(height: 25)
                        Text("Информация об автомобиле")
                            .font(.custom("Verdana-Bold", size: 18))
                        Spacer().frame(height: 20)
                        engineInfoView
                        Divider().frame(width: 260)
                        transmissionView
                        Divider().frame(width: 250)
                        carEquipmentSliderView
                        insuranceToggleView
                        Divider().frame(width: 260)
                        Spacer().frame(height: 25)
                        totalBillView
                        Spacer().frame(height: 20)
                        orderButtonView
                        Spacer().frame(height: 32)
                    }
                    
                }
                
            }
        }
    }
    
    // MARK: - Visual Elements
    
    private var shopLogoView: some View {
        HStack(alignment: .center) {
            Spacer().frame(width: 145)
            Image("shopName")
            Spacer().frame(width: 109)
            Button(action: {
                isSharePresented.toggle()
            }) {
                Image(Constants.shareButton)
                    .tint(.white)
            }.sheet(isPresented: $isSharePresented, content: {
                ActivityView(activityItems: [
                    """
                    Покупайте машину \(viewModel.carModels[viewModel.segmentIndex].carModel) за - \(viewModel.carPrice) рублей
                    """
                ])
            })
            Spacer().frame(width: 19)
            
        }
    }
    
    private var carImageView: some View {
        Image(viewModel.carModels[viewModel.segmentIndex].carImageName)
            .resizable()
            .frame(width: 345, height: 198, alignment: .center)
    }
    
    private var segmentView: some View {
        Picker(selection: Binding(get: {
            viewModel.segmentIndex
        }, set: { newValue in
            viewModel.segmentIndex = newValue
            viewModel.updateTotalPrice(change: .segment)
        })) {
            ForEach(viewModel.carModels.indices, id: \.self) { index in
                Text("\(viewModel.carModels[index].carModel)")
            }
        } label: {
        }
        .pickerStyle(.segmented)
        .background(Color.white)
        .cornerRadius(8)
        .padding()
    }
    
    private var carCharacteristicsView: some View {
        return Image("qwe")
    }
    
    private var carEquipmentSliderView: some View {
        VStack(alignment: .leading) {
            Text("Комплектация")
            Slider(value: Binding(get: {
                viewModel.sliderValue
            }, set: { newValue in
                viewModel.sliderValue = newValue
            }), in: 0...4, step: 1) { _ in
                viewModel.updateTotalPrice(change: .slider)
            }
                .accentColor(.black)
                .onAppear {
                    let progressCircleConfig = UIImage.SymbolConfiguration(scale: .small)
                    UISlider.appearance()
                        .setThumbImage(UIImage(systemName: "circle.fill",
                                               withConfiguration: progressCircleConfig), for: .normal)
                }
            HStack {
                Spacer()
                Text(Constants.joy)
                Spacer()
                Text(Constants.lifestyle)
                Spacer()
                Text(Constants.ultimate)
                Spacer()
                Text(Constants.active)
                Spacer()
                Text(Constants.supreme)
                Spacer()
            }
        }
        .padding()
    }
    
    private var orderButtonView: some View {
        Button(action: {
            isOrderButtonTapped.toggle()
        }) {
            Text(Constants.orderButton)
                .font(.custom("Verdana-bold", size: 18))
        }
        .frame(width: 358, height: 48, alignment: .center)
        .background(.viewBackground)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
        .confirmationDialog(Constants.actionSheetText, isPresented: $isOrderButtonTapped, titleVisibility: .visible) {}
    }
    
    private var engineInfoView: some View {
        HStack {
            Text("Двигатель")
            Spacer()
            Text("1.6 Turbo")
        }
        .padding()
    }
    
    private var transmissionView: some View {
        HStack {
            Text("Привод")
            Spacer()
            Text("AWD")
        }
        .padding()
    }
    
    private var insuranceToggleView: some View {

        Toggle(isOn: $isInsuranceIncluded) {
            Text(Constants.toggleLabel)
        }
        .onChange(of: isInsuranceIncluded, { oldValue, newValue in
            if newValue == false {
                viewModel.updateTotalPrice(
                    change: .toggle)
            }
        })
        .alert(isPresented: $isInsuranceIncluded) {
                    Alert(
                        title: Text(Constants.alertText),
                        message: Text(Constants.alertMessage),
                        primaryButton: .default(Text(Constants.alertPrimaryButton)),
                        secondaryButton: .cancel(Text(Constants.alertSecondaryButton)) {
                            if !isInsuranceIncluded {
                                viewModel.updateTotalPrice(
                                    change: .toggle)
                            }
                            isInsuranceIncluded.toggle()
                        }
                    )}
        .padding()
    }
    
    private var totalBillView: some View {
        HStack {
            Text(Constants.price)
            Spacer()
            Text("\(viewModel.formatToString(number: viewModel.totalPrice)) руб")
        }
        .font(.custom("Verdana-bold", size: 18))
        .padding()
    }
}

#Preview {
    ContentView()
}
