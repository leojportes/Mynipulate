//
//  MenuCollectionCell.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

final class MenuCollectionCell: UICollectionViewCell, ViewCodeContract {

    // MARK: - Private properties
    private var parkingSpaceNum: String = .empty

    // MARK: - Properties
    static let identifier = "MenuCollectionCell"

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 5
        contentView.roundCorners(cornerRadius: 10)
        contentView.backgroundColor = .white
        self.addShadow()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Viewcode
    private lazy var titleLabel = MNLabel(
        font: .boldSystemFont(ofSize: 12),
        textColor: .neutralHigh
    ) .. {
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    private lazy var iconView = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var lockView = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints  = false
        $0.image = UIImage(systemName: "exclamationmark.lock.fill")
        $0.heightAnchor(.xLarge)
        $0.setImageColor(color: .purpleLight.withAlphaComponent(0.8))
        $0.widthAnchor(.xLarge)
        $0.isHidden = true
    }

    // MARK: - Setup viewcode
    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(lockView)
    }

    func setupConstraints() {
        
        titleLabel
            .topAnchor(in: iconView, attribute: .bottom, padding: .xSmall2)
            .leftAnchor(in: contentView, padding: .xSmall2)
            .rightAnchor(in: contentView, padding: .xSmall2)

        iconView
            .center(in: contentView)
            .topAnchor(in: contentView, padding: 18)
            .heightAnchor(30)
            .widthAnchor(30)

        lockView
            .topAnchor(in: self, padding: -8)
            .rightAnchor(in: self, padding: -8)
    }

    func bind(title: String, image: UIImage, isBlock: Bool = false) {
        titleLabel.text = title
        iconView.image = image
        iconView.setImageColor(color: .purpleLight)
        lockView.isHidden = isBlock.not
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        iconView.image = nil
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
