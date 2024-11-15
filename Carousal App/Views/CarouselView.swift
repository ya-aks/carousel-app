//
//  CarouselView.swift
//  Carousal App
//
//  Created by akshay yadav on 15/11/24.
//
 
import UIKit
 
/// Configuration for the CarouselView
struct CarouselConfiguration {
    var scaleFactor: CGFloat
    var maxItemSize: CGFloat
    var defaultIndex: Int
    
    init(scaleFactor: CGFloat = 1.3,
         maxItemSize: CGFloat = 250,
         defaultIndex: Int = 0) {
        self.scaleFactor = scaleFactor
        self.maxItemSize = maxItemSize
        self.defaultIndex = defaultIndex
    }
}
 
/// A customizable carousel view that displays a collection of views with a scaling effect
final class CarouselView: UIView {
    // MARK: - Properties
    
    private var itemSize: CGSize = .zero
    private var itemViews: [UIView] = []
    private var configuration: CarouselConfiguration
    private var currentIndex: Int
    
    private var scaleFactor: CGFloat {
        configuration.scaleFactor
    }
    
    private var maxItemSize: CGFloat {
        configuration.maxItemSize
    }
    
    /// The scroll view that contains the carousel items
    private lazy var containerScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = false
        view.delegate = self
        return view
    }()
    
    /// The page control that shows the current page of the carousel
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .gray.withAlphaComponent(0.5)
        control.currentPageIndicatorTintColor = .gray
        return control
    }()
    
    // MARK: - Initialization
    
    /// Initializes the CarouselView with the given views and configuration
    /// - Parameters:
    ///   - views: An array of UIViews to be displayed in the carousel
    ///   - configuration: The configuration for the carousel (optional)
    init(views: [UIView],
         configuration: CarouselConfiguration = CarouselConfiguration()) {
        self.itemViews = views
        self.configuration = configuration
        // We should check the default Index should be in range, we dont have control over what the client can send
        if configuration.defaultIndex < 0 {
            self.currentIndex = 0
        } else if configuration.defaultIndex > views.count {
            self.currentIndex = views.count - 1
        } else {
            self.currentIndex = configuration.defaultIndex
        }
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    /// Sets up the views for the carousel
    private func setupViews() {
        addSubview(containerScrollView)
        addSubview(pageControl)
        
        setupConstraints()
    }
    
    /// Sets up the constraints for the carousel views
    private func setupConstraints() {
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerScrollView.bottomAnchor.constraint(greaterThanOrEqualTo: pageControl.topAnchor, constant: 16),
            
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
            pageControl.widthAnchor.constraint(equalToConstant: 100),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    /// Lays out subviews and updates the carousel
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let availableHeight = bounds.height - pageControl.bounds.height - 32
        let scaledHeight = min(availableHeight, maxItemSize * scaleFactor)
        let normalHeight = scaledHeight / scaleFactor
        
        itemSize = CGSize(width: normalHeight, height: normalHeight)
        
        setupCarousel()
        setupPageControl()
        updateCarouselTransform()
    }
    
    /// Sets up the carousel with the item views and set the current Index view in center
    private func setupCarousel() {
        itemViews.forEach { $0.removeFromSuperview() }
        
        let totalWidth = CGFloat(itemViews.count) * itemSize.width
        let horizontalInset = (bounds.width - itemSize.width) / 2
        containerScrollView.contentSize = CGSize(width: totalWidth + 2 * horizontalInset, height: itemSize.height * scaleFactor)
        containerScrollView.contentInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        
        for (index, itemView) in itemViews.enumerated() {
            let xPosition = CGFloat(index) * itemSize.width
            let yPosition = (containerScrollView.bounds.height - itemSize.height) / 2
            itemView.frame = CGRect(x: xPosition, y: yPosition, width: itemSize.width, height: itemSize.height)
            
            containerScrollView.addSubview(itemView)
        }
        
        let offsetX = CGFloat(currentIndex) * itemSize.width - horizontalInset
        containerScrollView.contentOffset.x = offsetX
    }
    
    /// Sets up the page control
    private func setupPageControl() {
        pageControl.numberOfPages = itemViews.count
        pageControl.currentPage = currentIndex
    }
    
    // MARK: - Carousel Logic
    
    /// Updates the transform of the carousel items based on their position
    private func updateCarouselTransform() {
        let centerX = containerScrollView.contentOffset.x + containerScrollView.bounds.width / 2
        let maxDistance = itemSize.width / 2
        
        for (_, imageView) in itemViews.enumerated() {
            let distance = abs(imageView.center.x - centerX)
            
            let identityScaleFactor = 1.0
            let scaleFactor = max(identityScaleFactor, min(self.scaleFactor, self.scaleFactor - (distance / maxDistance) * (self.scaleFactor - identityScaleFactor)))
            
            UIView.animate(withDuration: 0.3) {
                imageView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                imageView.layer.zPosition = 1000 - distance
            }
        }
    }
    
    /// Scrolls the carousel to the nearest item
    private func scrollToNearestItem() {
        let contentOffsetX = containerScrollView.contentOffset.x + containerScrollView.contentInset.left
        let itemFullWidth = itemSize.width
        let index = round(contentOffsetX / itemFullWidth)
        let newContentOffsetX = index * itemFullWidth - containerScrollView.contentInset.left
        containerScrollView.setContentOffset(CGPoint(x: newContentOffsetX, y: 0), animated: true)
        currentIndex = Int(index)
        pageControl.currentPage = currentIndex
    }
}
 
// MARK: - UIScrollViewDelegate
 
extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCarouselTransform()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        scrollToNearestItem()
    }
}
