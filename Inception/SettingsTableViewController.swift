//
//  SettingsTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 13.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var alarmDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notificationSwitch:UISwitch!
    
    private var datePickerHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "settings".localized;
        
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.notificationSwitch.on = SettingsFactory.boolForKey(SettingsFactory.SettingKey.Notifications)!
        self.datePicker.date = SettingsFactory.objectForKey(SettingsFactory.SettingKey.NotificationAlarmDate) as! NSDate
        self.didChangeDate()
        self.toggleDatePicker()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didChangeDate() {
        alarmDateLabel.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.NotificationAlarmDate, value: datePicker.date)
    }
    
    @IBAction func didChangeNotificationSwitch(sender:UISwitch) {
        SettingsFactory.setBoolForKey(SettingsFactory.SettingKey.Notifications, value: sender.on)
    }
    
    private func toggleDatePicker() {
        // Force table to update its contents
        datePickerHidden = !datePickerHidden
        
        if datePickerHidden {
            UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.datePicker.alpha = 0.0
                }, completion: { (_) -> Void in
                    self.triggerTableViewUpdate()
            })
        }
        else {
            UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.datePicker.alpha = 1.0
                }, completion: { (_) -> Void in
                    self.triggerTableViewUpdate()
            })
        }
    }
    
    func triggerTableViewUpdate() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = SettingsRow(indexPath: indexPath)
        
        return datePickerHidden && row == .DatePicker ? 0 : super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = SettingsRow(indexPath: indexPath)
        
        switch (row) {
        case .Alarm:
            toggleDatePicker()
        case .Cache :
            let vc : CacheTableViewController = storyboard?.instantiateViewControllerWithIdentifier("CacheTableViewController") as! CacheTableViewController
            vc.showsImageCache = false
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case .ImageCache :
            let vc : CacheTableViewController = storyboard?.instantiateViewControllerWithIdentifier("CacheTableViewController") as! CacheTableViewController
            vc.showsImageCache = true
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default:
            ()
        }
    }
}
