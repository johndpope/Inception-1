//
//  UpcomingEpisodesCalendarViewController+CVCalendar.swift
//  Inception
//
//  Created by David Ehlen on 27.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import CVCalendar

extension UpcomingEpisodesCalendarViewController : CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {

    func presentationMode() -> CalendarMode {
        return .WeekView
    }
    
    func firstWeekday() -> Weekday {
        return .Monday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func didSelectDayView(dayView: DayView) {
        if let convertedDate = dayView.date.convertedDate() {
            self.loadEntriesForDate(convertedDate)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        if let convertedDate = dayView.date.convertedDate() {
            return self.hasEntryForDate(convertedDate)
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        var colors:[UIColor] = []
        if let convertedDate = dayView.date.convertedDate() {
            let numberOfDots = self.numberOfEpisodesForDate(convertedDate)
            for _ in 0..<numberOfDots {
                colors.append(UIColor.whiteColor())
            }
        }
        return colors
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func dayLabelWeekdayInTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func dayLabelWeekdayOutTextColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    }
    
    func dayLabelWeekdaySelectedBackgroundAlpha() -> CGFloat {
        return 1.0
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundAlpha() -> CGFloat {
        return 1.0
    }
    
    func dayLabelPresentWeekdayHighlightedBackgroundColor() -> UIColor {
        return UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    }
    
    func dayLabelPresentWeekdayTextColor() -> UIColor {
        return UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    }
}
