//
//  ActivityView.swift
//  SwiftUICarShop
//
//  Created by Levon Shaxbazyan on 03.05.24.
//

import SwiftUI

/// Для возможности поделится информацией о машине
struct ActivityView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    
    public var activityItems: [Any]
    public var applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
}
