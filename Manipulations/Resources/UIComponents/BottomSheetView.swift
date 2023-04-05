//
//  BottomSheetView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

public class BottomSheetView: UIView {

    private let swipeThreshold: CGFloat = 140
    private var viewTranslation = CGPoint(x: 0, y: 0)

    private(set) lazy var baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 15, typeCorners: [.topLeft, .topRight])
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var gripView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
        $0.roundCorners(cornerRadius: 2)
    }

    public init(height: CGFloat = 300) {
        super.init(frame: .zero)
        setupView()
        baseView
            .heightAnchor(height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleDismiss(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            viewTranslation = recognizer.translation(in: self)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                guard self.viewTranslation.y > 0 else {return}
                self.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < swipeThreshold {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.transform = .identity
                })
            } else {
                UIViewController.findCurrentController()?.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }

    private func setupView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(recognizer:)))
        addGestureRecognizer(panGestureRecognizer)
        backgroundColor = .white
        addSubview(baseView)
        baseView.addSubview(gripView)
        
        gripView
            .topAnchor(in: baseView, padding: 10)
            .centerX(in: baseView)
            .heightAnchor(4)
            .widthAnchor(35)

        baseView
            .leftAnchor(in: self)
            .rightAnchor(in: self)
            .bottomAnchor(in: self, layoutOption: .useMargins)
        roundCorners(cornerRadius: 15, typeCorners: [.topLeft, .topRight])
    }
}
