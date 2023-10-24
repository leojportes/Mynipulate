//
//  MNPizzaChartView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 31/05/23.
//

import UIKit

public class MNPizzaChartView: UIView {
    private var values: [Double]
    private var colors: [UIColor]

    public init(values: [Double], colors: [UIColor]) {
        self.values = values
        self.colors = colors
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        let totalValues = values.reduce(0, +)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        var startAngle: CGFloat = 0

        for (index, value) in values.enumerated() {
            let endAngle = startAngle + CGFloat(value) / CGFloat(totalValues) * 2 * .pi

            context.move(to: center)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

            let colorIndex = index % colors.count
            let color = colors[colorIndex]
            color.setFill()

            context.closePath()
            context.fillPath()

            startAngle = endAngle
        }
    }
}
