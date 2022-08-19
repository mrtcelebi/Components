//
//  CircleProgressView.swift
//  Components
//
//  Created by Murat Celebi on 19.08.2022.
//

import UIKit
import TinyConstraints
import MobilliumBuilders

public class NKolayCircleProgresView: UIView {
    
    private let progressLayer = CAShapeLayer()
        
    private let maxAmount: Double
    private let amount: Double
    public var progressColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public init(amount: Double, maxAmount: Double, progressColor: UIColor) {
        self.amount = amount
        self.maxAmount = maxAmount
        self.progressColor = progressColor
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        let ringWidth: CGFloat = 10
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2 + 6, dy: ringWidth / 2 + 6))
        progressLayer.path = circlePath.cgPath
        progressLayer.strokeEnd = (amount * 0.75) / maxAmount
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }
}

public class CircleWithTitleProgressView: UIView {
        
    private lazy var circleView = NKolayCircleProgresView(amount: amount,
                                                          maxAmount: maxAmount,
                                                          progressColor: progressColor)
    
    private let titleLabel = UILabelBuilder()
        .font(.systemFont(ofSize: 13))
        .textColor(.green)
        .textAlignment(.right)
        .build()
    
    private let maxAmount: Double
    public let amount: Double
    private let title: String?
    private let progressColor: UIColor
    
    public var isSelected: Bool? {
        didSet {
            if isSelected == true {
                circleView.progressColor = progressColor
                titleLabel.textColor = .green
            } else {
                circleView.progressColor = .lightGray
                titleLabel.textColor = .lightGray
            }
        }
    }
    
    public init(amount: Double, maxAmount: Double, title: String?, progressColor: UIColor) {
        self.amount = amount
        self.maxAmount = maxAmount
        self.title = title
        self.progressColor = progressColor
        super.init(frame: .zero)
        addSubviews()
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(circleView)
        circleView.edgesToSuperview()
        
        let centerView = UIView()
        addSubview(centerView)
        centerView.centerXToSuperview()
        centerView.topToSuperview()
        centerView.bottomToSuperview()
        centerView.width(0.5)
        
        addSubview(titleLabel)
        titleLabel.trailingToLeading(of: centerView).constant = -10
    }
    
    private func configureContents() {
        titleLabel.text = title
    }
}

public class MultipleCircleProgressView: UIView {
    
    enum AnimationType {
        case hideAndShowAnimation
        case onlySelectOneAnimation
    }
    
    var padding: CGFloat = 0
    
    public var cellItems: [CircleWithTitleProgressView] = [] {
        didSet {
            cellItems = cellItems.sorted(by: { $0.amount > $1.amount })
            configureProgressViews()
        }
    }
 
    private var index = 0
    
    private var animationType: AnimationType = .hideAndShowAnimation
    
    public init() {
        super.init(frame: .zero)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProgressViews() {
        subviews.filter({ $0 is CircleWithTitleProgressView }).forEach({ $0.removeFromSuperview() })
        
        cellItems.forEach({ progressView in
            addSubview(progressView)
            progressView.topToSuperview().constant = padding
            progressView.leadingToSuperview().constant = padding
            progressView.trailingToSuperview().constant = -padding
            progressView.bottomToSuperview().constant = -padding
            padding += 20
        })
    }
    
    private func configureContents() {
        backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func viewTapped() {
        switch animationType {
        case .hideAndShowAnimation:
            hideAndShowAnimation()
        case .onlySelectOneAnimation:
            onlySelectOneAnimation()
        }
    }
    
    private func hideAndShowAnimation() {
        let itemCount = cellItems.count
        if index == itemCount {
            index = 0
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
                self.cellItems.forEach({ $0.isSelected = true })
                self.cellItems.forEach({ $0.isHidden = false })
            }
            animationType = .onlySelectOneAnimation
            onlySelectOneAnimation()
            return
        }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.cellItems[self.index].isSelected = true
            self.cellItems[self.index].isHidden = false
            self.cellItems[(self.index + 1)..<itemCount].forEach({ $0.isHidden = true })
        }
        index += 1
    }
    
    private func onlySelectOneAnimation() {
        let itemCount = cellItems.count
        if index == itemCount {
            index = 0
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
                self.cellItems.forEach({ $0.isSelected = true })
            }
            animationType = .hideAndShowAnimation
            return
        }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.cellItems.forEach({ $0.isSelected = false })
            self.cellItems[self.index].isSelected = true
        }
        index += 1
    }
}

