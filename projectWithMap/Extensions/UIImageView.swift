//
//  UIImageView.swift
//  projectWithMap
//
//  Created by Alibek Baisholanov on 19.01.2025.
//

import Foundation
import UIKit

extension UIImageView {
    //MARK: round up image
    func makeCircular(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    
}
