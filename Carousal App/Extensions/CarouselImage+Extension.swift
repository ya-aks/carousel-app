//
//  CarouselImage+Extension.swift
//  Carousal App
//
//  Created by akshay yadav on 15/11/24.
//

import UIKit
extension CarouselImage {
    func fetchImage() async -> UIImage? {
        switch self {
        case .asset(let imageName):
            // Use the new asset loading API
            return UIImage(named: imageName)?.preparingForDisplay()
        case .url(let urlString):
            guard let url = URL(string: urlString) else { return nil }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                return UIImage(data: data)?.preparingForDisplay()
            } catch {
                print("Error loading image from URL: \(error)")
                return nil
            }
        }
    }
}
