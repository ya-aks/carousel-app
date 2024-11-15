//
//  ViewController.swift
//  Carousal App
//
//  Created by akshay yadav on 14/11/24.
//

import UIKit

final class CarousalViewController: UIViewController {

    private var viewModel: CarouselViewModel
    
    init(viewModel: CarouselViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var carouselView: CarouselView = {
        let defaultIndex = viewModel.cards.count / 2
        let view = CarouselView(views: viewModel.cards.map({ card in
            CarouselCardView(card: card)
        }), configuration: CarouselConfiguration(defaultIndex: viewModel.cards.count + 5))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCarouselView()
    }
    
    private func setupCarouselView() {
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
