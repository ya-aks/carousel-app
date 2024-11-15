//
//  CarouselCardView.swift
//  Carousal App
//
//  Created by akshay yadav on 15/11/24.
//

import UIKit

/// CarouselCardView is a custom UIView that displays a single card in a carousel.
/// It loads and displays an image asynchronously based on the provided CarouselCardModel.
final class CarouselCardView: UIView {
    private var card: CarouselCardModel
    private let imageView: UIImageView
    private var carouselImage: CarouselImage {
        card.image
    }
    
    /// Initializes a new CarouselCardView with the given card model.
    /// - Parameter card: The CarouselCardModel containing the card's data.
    init(card: CarouselCardModel) {
        self.card = card
        self.imageView = UIImageView()
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the view's hierarchy, configures the image view, and loads the image.
    private func setupView() {
        setupImageView()
        loadImage()
    }
    
    // Add Image View to Hierarchy with required configuration
    private func setupImageView() {
        addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "placeholder")
        
        setupImageConstriants()
    }
    
    // Set up constraints to make the image view fill the entire CarouselCardView
    private func setupImageConstriants() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // Asynchronously fetch and display the actual image
    private func loadImage() {
        Task(priority: .userInitiated) {
            if let image = await carouselImage.fetchImage() {
                await MainActor.run {
                    // Animate the transition from placeholder to actual image
                    UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve) {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
