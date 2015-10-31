//
//  UpcomingEpisodesCalendarViewController+CVCalendar.swift
//  Inception
//
//  Created by David Ehlen on 27.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import JTCalendar

extension UpcomingEpisodesCalendarViewController : JTCalendarDelegate {
    
    func setupCalendar() {
        calendarManager.delegate = self
        calendarManager.contentView = calendarView
        calendarManager.dateHelper.calendar().firstWeekday = 2
        calendarManager.setDate(self.selectedDate)
        calendarManager.settings.weekModeEnabled = true
        calendarManager.reload()
        
    }
    
    func updateMonthText() {
        var text = ""
        let comps = self.calendarManager.dateHelper.calendar().components([.Year, .Month], fromDate:self.selectedDate)
        var currentMonthIndex = comps.month
        
        let dateFormatter = self.calendarManager.dateHelper.createDateFormatter()
        
        dateFormatter.timeZone = self.calendarManager.dateHelper.calendar().timeZone
        dateFormatter.locale = self.calendarManager.dateHelper.calendar().locale
        
        while currentMonthIndex <= 0 {
            currentMonthIndex += 12
        }
        text = dateFormatter.standaloneMonthSymbols[currentMonthIndex - 1].capitalizedString
        text += " \(comps.year)"
        self.title = text
    }
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        let calDayView = dayView as! JTCalendarDayView
        calDayView.hidden = false
       
        if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: calDayView.date) && !calendarManager.dateHelper.date(selectedDate, isTheSameDayThan: NSDate()){
            calDayView.textLabel.textColor = UIColor(red:1.0, green:222.0/255.0, blue:96.0/255.0, alpha:1.0)
            calDayView.circleView.hidden = true
            calDayView.dotView.backgroundColor = UIColor.whiteColor()
        }
        
       else if calendarManager.dateHelper.date(selectedDate, isTheSameDayThan: calDayView.date) {
            calDayView.circleView.hidden = false
            calDayView.circleView.backgroundColor = UIColor(red:1.0, green:222.0/255.0, blue:96.0/255.0, alpha:1.0)
            calDayView.dotView.backgroundColor = UIColor.whiteColor()
            calDayView.textLabel.textColor = UIColor.whiteColor()
        }
       else {
            calDayView.circleView.hidden = true
            calDayView.dotView.backgroundColor = UIColor.whiteColor()
            calDayView.textLabel.textColor = UIColor.whiteColor()
        }
        
        if self.hasEntryForDate(calDayView.date) {
            calDayView.dotView.hidden = false
        }
        else {
             calDayView.dotView.hidden = true
        }
    }
    

    func calendarBuildWeekDayView(calendar: JTCalendarManager!) -> UIView! {
        let view = JTCalendarWeekDayView()
        for view in view.dayViews {
            let label = view as! UILabel
            label.textColor = UIColor.darkGrayColor()
            label.font = UIFont(name: "Avenir", size: 10)
        }
        return view
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        let calDayView = dayView as! JTCalendarDayView
        self.selectedDate = calDayView.date
        self.calendarManager.setDate(calDayView.date)

        calDayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
        
        UIView.transitionWithView(calDayView, duration: 0.3, options:[.CurveEaseInOut], animations: {
                calDayView.circleView.transform = CGAffineTransformIdentity
                self.calendarManager.reload()
            }, completion: nil)
        self.loadEntriesForDate(calDayView.date)
        self.updateMonthText()
    }
}
