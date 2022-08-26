//
//  TestButton.swift
//  Components
//
//  Created by Murat Celebi on 25.08.2022.
//

import UIKit

class TestButton: UIView {
    
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureContents()
        setLocalize()
    }
    
    // swiftlint:disable fatal_error unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // swiftlint:enable fatal_error unavailable_function
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    
    var isAnimate = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if widthConstraint == nil {
            widthConstraint = button.width(frame.width)
            self.button.trailingToSuperview()
        }
        button.layer.cornerRadius = frame.height / 2
        button.clipsToBounds = true
    }
}

// MARK: - UILayout
extension TestButton {
    
    private func addSubviews() {
        addSubview(button)
        button.topToSuperview()
        button.bottomToSuperview()
        button.heightToSuperview()
    }
}

// MARK: - Configure & SetLocalize
extension TestButton {
    
    private func configureContents() {
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setLocalize() {
        
    }
    
    private func animate() {
        self.widthConstraint?.constant = frame.height
        animateLayout()
    }
    
    private func animateBack() {
        widthConstraint?.constant = frame.width
        animateLayout()
    }
    
    private func animateLayout() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Actions
extension TestButton {
    
    @objc
    private func buttonTapped() {
        isAnimate ? animate() : animateBack()
        isAnimate.toggle()
    }
}
