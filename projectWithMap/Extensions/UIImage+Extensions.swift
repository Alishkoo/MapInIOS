//
//  UIImage+Extensions.swift
//  projectWithMap
//
//  Created by Alibek Baisholanov on 19.01.2025.
//

import Foundation
import UIKit

extension UIImage {
    //MARK: resize to annotation
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    
    func makeCircular() -> UIImage? {
        // Определяем размер квадрата для маски (это будет наименьший размер между шириной и высотой)
        let size = min(self.size.width, self.size.height)
        
        // Создаем графический контекст для рисования
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { context in
            // Рисуем круглый путь
            let rect = CGRect(x: 0, y: 0, width: size, height: size)
            context.cgContext.addEllipse(in: rect)
            context.cgContext.clip()
            
            // Рисуем изображение в рамке круга
            self.draw(in: rect)
        }
    }
}
