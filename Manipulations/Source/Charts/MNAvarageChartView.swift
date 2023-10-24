//
//  MNAvarageChartView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 19/10/23.
//

import UIKit
import Charts

final class MNAvarageChartView: LineChartView {

    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let dataSet = LineChartDataSet(entries: dataEntries, label: "Aproveitamento médio (%)")
        dataSet.colors = [.clear]
        dataSet.mode = .cubicBezier
        dataSet.axisDependency = .left
        dataSet.setColor(.misteryGreen)
        dataSet.drawCirclesEnabled = true
        dataSet.setCircleColor(.misteryGreen)
        dataSet.lineWidth = 2
        dataSet.circleRadius = 3
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = .misteryGreen.withAlphaComponent(0.6)

        

        dataSet.highlightColor = .misteryGreen
        dataSet.drawCircleHoleEnabled = true
        dataSet.cubicIntensity = 0.1
        self.gridBackgroundColor = .clear
        self.xAxis.drawGridLinesEnabled = false
        self.leftAxis.drawGridLinesEnabled = false
        self.rightAxis.drawGridLinesEnabled = false
        self.drawBordersEnabled = false

        let data = LineChartData(dataSet: dataSet)
        self.data = data



        // Configurar eixo X
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        xAxis.labelPosition = .bottom

        // Configurar eixo Y
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = values.max()! + 10.0

        customizeLegend()

        zoom(scaleX: 0.5, scaleY: 1.0, x: 0.0, y: 0.0) // Diminui o zoom no eixo X

        // Atualize o gráfico
        notifyDataSetChanged()

    }

    func customizeLegend() {
        legend.form = .circle // Use um círculo em vez de um quadrado
        legend.formSize = 6.0 // Ajuste o tamanho do círculo
        legend.formLineWidth = 3.0 // Ajuste a espessura da linha
        legend.formLineDashPhase = 3.0 // Ajuste a fase da linha tracejada

        legend.formLineDashLengths = [10.0, 5.0] // Ajuste o padrão da linha tracejada

        legend.font = .systemFont(ofSize: 10)
        legend.textColor = .misteryGreen
    }

}
