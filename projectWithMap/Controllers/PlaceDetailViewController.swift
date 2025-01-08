//
//  PlaceDetailViewController.swift
//  projectWithMap
//
//  Created by Alibek Baisholanov on 08.01.2025.
//

import Foundation
import UIKit

class PlaceDetailViewController: UIViewController {
    
    let nameLabel: UITextView
    let place: PlaceAnnotation
    
    init(place: PlaceAnnotation){
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        
        stackView.addArrangedSubview(nameLabel)
        
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        view.addSubview(stackView)
    }
    
}
