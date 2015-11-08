//
//  StatsViewController+Charts.swift
//  Inception
//
//  Created by David Ehlen on 27.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import Charts

extension StatsTableViewController : ChartViewDelegate {
    
    func setupChart() {
        self.horizontalBarChart.delegate = self
        self.horizontalBarChart.descriptionText = ""
        self.horizontalBarChart.noDataTextDescription = ""
        self.horizontalBarChart.drawBarShadowEnabled = false
        self.horizontalBarChart.drawValueAboveBarEnabled = true
        self.horizontalBarChart.pinchZoomEnabled = false
        self.horizontalBarChart.drawGridBackgroundEnabled = false
        
        let xAxis = self.horizontalBarChart.xAxis
        xAxis.labelPosition = .Bottom
        xAxis.labelFont = UIFont.systemFontOfSize(10)
        xAxis.labelTextColor = ThemeManager.sharedInstance.currentTheme.textColor
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.gridLineWidth = 0.0
        
        let yAxis = self.horizontalBarChart.leftAxis
        yAxis.labelFont = UIFont.systemFontOfSize(10)
        yAxis.labelTextColor = ThemeManager.sharedInstance.currentTheme.textColor
        yAxis.labelPosition = .OutsideChart
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        yAxis.gridLineWidth = 0.0
        
        self.horizontalBarChart.rightAxis.drawGridLinesEnabled = false
        self.horizontalBarChart.rightAxis.drawAxisLineEnabled = true

        self.horizontalBarChart.legend.position = .BelowChartLeft
        self.horizontalBarChart.legend.form = .Circle
        self.horizontalBarChart.legend.formSize = 8.0
        self.horizontalBarChart.legend.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        self.horizontalBarChart.legend.font = UIFont.systemFontOfSize(11)
        self.horizontalBarChart.legend.xEntrySpace = 4.0
        
        self.horizontalBarChart.animate(yAxisDuration: 2.5)
    }

    func setChartData(keyLabels:[String], yValues:[Int]) {
        var yVals:[BarChartDataEntry] = []
        for i in 0..<yValues.count {
            let entry = BarChartDataEntry(value:Double(yValues[i]), xIndex: i)
            yVals.append(entry)
        }
        let set = BarChartDataSet(yVals: yVals, label: "timeSpent".localized)
        set.barSpace = 0.2
        set.colors = [ThemeManager.sharedInstance.currentTheme.primaryTintColor]
        
        let barChartData = BarChartData(xVals: keyLabels, dataSet: set)
        barChartData.setValueTextColor(ThemeManager.sharedInstance.currentTheme.textColor)
        barChartData.setValueFont(UIFont.systemFontOfSize(14))
        barChartData.setDrawValues(false)
        self.horizontalBarChart.data = barChartData
    }
}
