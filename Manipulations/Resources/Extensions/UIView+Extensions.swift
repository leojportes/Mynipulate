//
//  UIView+Extensions.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

extension UIView {
    
    /// Adiciona bordas arredondadas em um componente UIView
    func roundCorners(cornerRadius: CGFloat, typeCorners: CACornerMask? = nil, all: Bool = false) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.maskedCorners = typeCorners ?? [.topLeft, .topRight, .bottomLeft, .bottomRight]
    }
    
    /// Adiciona sombra em uma UIView
    func addShadow(color: UIColor? = .neutral, size: CGSize = CGSize(width: -1, height: 1), opacity: Float = 0.3, radius: CGFloat = 2) {
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func addTopBorder(with color: UIColor? = .separator, andWidth borderWidth: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func addBottomBorder(with color: UIColor? = .separator, andWidth borderWidth: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
}

extension CACornerMask {
    static public let bottomRight: CACornerMask = .layerMaxXMaxYCorner
    static public let bottomLeft: CACornerMask = .layerMinXMaxYCorner
    static public let topRight: CACornerMask = .layerMaxXMinYCorner
    static public let topLeft: CACornerMask = .layerMinXMinYCorner
}

extension UIView {
    func loadingIndicatorView(show: Bool = true) {
        if show {
            DispatchQueue.main.async {
                let indicator = UIActivityIndicatorView()
                self.addSubview(indicator)
                let buttonHeight = self.bounds.size.height
                let buttonWidth = self.bounds.size.width
                indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
                indicator.color = .darkGray
                self.layer.opacity = 0.5
                indicator.startAnimating()
            }
        } else {
            for view in self.subviews {
                if let indicator = view as? UIActivityIndicatorView {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    self.layer.opacity = 1
                }
            }
        }
    }
}


extension UIView {
    
    func addGradientColor(
        _ colorTop: CGColor = UIColor.darkGreen.cgColor,
        _ colorBottom: CGColor = UIColor.misteryGreen.cgColor,
        baseView: UIView? = nil,
        maxX: CGFloat = 100.0,
        maxY: CGFloat = 500.0
    ) {
        let gradientLayer = CAGradientLayer()
        let base = baseView ?? self
        gradientLayer.frame = base.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0,y: 0)
        gradientLayer.endPoint = CGPoint(x: maxX/base.bounds.width, y: maxY/base.bounds.height)
        base.layer.insertSublayer(gradientLayer, at: 0)
    }

}
