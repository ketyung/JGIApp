//
//  ShareView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 08/08/2021.
//


import SwiftUI



struct ShareView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ShareView>) {
        // empty
    }
}
