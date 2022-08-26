//
//  ViewController.swift
//  Components
//
//  Created by Murat Celebi on 19.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let circleProgressView = MultipleCircleProgressView()

    private let button = TestButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureContents()
    }
    
    private func addSubviews() {
        view.addSubview(circleProgressView)
        circleProgressView.centerInSuperview()
        circleProgressView.size(.init(width: 250, height: 250))
        
        view.addSubview(button)
        button.topToBottom(of: circleProgressView).constant = 50
        button.size(.init(width: 200, height: 50))
        button.centerXToSuperview()
    }

    private func configureContents() {
        let items = [CircleWithTitleProgressView(amount: 3000, maxAmount: 5000, title: "Bakiye", progressColor: .green),
                     CircleWithTitleProgressView(amount: 2000, maxAmount: 5000, title: "Döviz", progressColor: .green),
                     CircleWithTitleProgressView(amount: 1000, maxAmount: 5000, title: "Borç", progressColor: .green),
                     CircleWithTitleProgressView(amount: 5000, maxAmount: 5000, title: "Bono", progressColor: .green),
                     CircleWithTitleProgressView(amount: 4000, maxAmount: 5000, title: "Fon", progressColor: .green)]
        
        circleProgressView.cellItems = items
    }
}
