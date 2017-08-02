//
//  LYDatePickerView.swift
//  i行销
//
//  Created by Gordon on 2017/7/4.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

protocol LYDatePickerViewDelegate: NSObjectProtocol {
    func datePickerActionSelected(picker:LYDatePickerView, dateStr: String)
}

class LYDatePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: LYDatePickerViewDelegate?
    var selectCallBack: (([Int],String) -> Void)?
    
    private var yearArr = [Int]()
    private var monthArr = [Int]()
    private var dayArr = [Int]()
    private var selDateArr = [Int]()
    private var selDateStr = ""
    private var currentYear =  2017
    private var currentMonth = 7
    private var currentDay = 7
    
    private var yearIndex = 0
    private var monthIndex = 0
    private var dayIndex = 0
    
    private var containerView: UIView!
    private var titleLabel: UILabel!
    private var dateView:   UIView!
    private var datePicker: UIPickerView!
    private var doneBtn:    LYFrameButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWid(), height: kScreenHei())
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        self.p_initSubviews()
    }
    
    // MARK: - ********* Publick Method
    func show() {
        let keyWindow = UIApplication.shared.keyWindow
        containerView.top = self.height
        self.backgroundColor = UIColor.init(white: 0, alpha: 0)
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
            self.containerView.top = self.height - kFitCeilWid(250)
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0)
            self.containerView.top = self.height
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    // MARK: === 设置初始位置
    func ly_setSelectedDate(_ date: [Int]?) {
        
        if let selDate = date, selDate.count == 3  {
            selDateArr = selDate
        }
        yearIndex = yearArr.index(of: selDateArr[0]) ?? (yearArr.count - 1)
        monthIndex = monthArr.index(of: selDateArr[1]) ?? (monthArr.count - 1)
        _ = self.p_getDaysFrom(year: yearArr[yearIndex], month: monthArr[monthIndex])
        dayIndex = dayArr.index(of: selDateArr[2]) ?? (dayArr.count - 1)
        datePicker.reloadAllComponents()
        datePicker.selectRow(yearIndex, inComponent: 0, animated: false)
        datePicker.selectRow(monthIndex, inComponent: 1, animated: false)
        datePicker.selectRow(dayIndex, inComponent: 2, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { 
            if let label = self.datePicker.view(forRow: self.yearIndex, forComponent: 0) as? UILabel {
                label.textColor = kThemeColor()
            }
            if let label = self.datePicker.view(forRow: self.monthIndex, forComponent: 1) as? UILabel {
                label.textColor = kThemeColor()
            }
            if let label = self.datePicker.view(forRow: self.dayIndex, forComponent: 2) as? UILabel {
                label.textColor = kThemeColor()
            }
        }
    }
    func ly_setSelectedDateStr(_ str: String?) {
        
        if let dateStr = str, dateStr.characters.count == 10 {
            selDateStr = dateStr
            let arr = selDateStr.components(separatedBy: "-")
            if arr.count == 3,
                let year = Int(arr[0]),
                let month = Int(arr[1]),
                let day = Int(arr[2]) {
                self.ly_setSelectedDate([year,month,day])
            }
        } else {
            self.ly_setSelectedDate(nil)
        }
    }

    
    // MARK: - ********* UIPickerView delegate and dataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return yearArr.count
        case 1:
            return monthArr.count
        case 2:
            return self.p_getDaysFrom(year: yearArr[yearIndex], month: monthArr[monthIndex])
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kFitCeilWid(34)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel!
        if let reuse = view as? UILabel {
            label = reuse
        } else {
            label = UILabel()
            label.textAlignment = .center
            label.font = kRegularFitFont(size: 14)
            label.textColor = kMidTitleColor()
        }
        var title = ""
        switch component {
        case 0:
            title = "\(yearArr[row])" + "年"
        case 1:
            title = "\(monthArr[row])" + "月"
        case 2:
            title = "\(dayArr[row])" + "日"
        default:
            title = ""
        }
        label.text = title
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let view = pickerView.view(forRow: row, forComponent: component)
        if let label = view as? UILabel {
            label.textColor = kThemeColor()
        }
        switch component {
        case 0:
            yearIndex = row
            selDateArr[0] = yearArr[yearIndex]
        case 1:
            monthIndex = row
            selDateArr[1] = monthArr[monthIndex]
        case 2:
            dayIndex = row
            selDateArr[2] = dayArr[dayIndex]
        default:
            break
        }
        if component == 0 {
            _ = self.p_reloadMonthFrom(year: yearArr[yearIndex])
            pickerView.reloadComponent(1)
            pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
            if let label = datePicker.view(forRow: monthIndex, forComponent: 1) as? UILabel {
                label.textColor = kThemeColor()
            }
        }
        if (component == 0) || (component == 1) {
            _ = self.p_getDaysFrom(year: yearArr[yearIndex], month: monthArr[monthIndex])
            if dayIndex > (dayArr.count - 1) {
                dayIndex = dayArr.count - 1
            }
            pickerView.reloadComponent(2)
            pickerView.selectRow(dayIndex, inComponent: 2, animated: true)
            if let label = datePicker.view(forRow: dayIndex, forComponent: 2) as? UILabel {
                label.textColor = kThemeColor()
            }
        }
    }
    
    // MARK: - ********* Private Method
    func p_actionDoneBtn() {
        self.hide()
        let selDateStr = String.init(format: "%d-%02d-%02d", selDateArr[0],selDateArr[1],selDateArr[2])
        if let callBack = selectCallBack {
            callBack(selDateArr,selDateStr)
        }
        delegate?.datePickerActionSelected(picker: self, dateStr: selDateStr)
    }
    func p_setUpConfig() {
        
        let date = Date()
        currentYear = date.component(.year) ?? 2017
        currentMonth = date.component(.month) ?? 1
        currentDay = date.component(.day) ?? 1
        selDateArr = [currentYear,currentMonth,currentDay]
        for idx in 1860...currentYear {
            yearArr.append(idx)
        }
        _ = self.p_reloadMonthFrom(year: currentYear)
        
    }
    func p_setDays(num: Int) {
        dayArr.removeAll()
        for idx in 1...num {
            dayArr.append(idx)
        }
    }
    func p_reloadMonthFrom(year: Int) -> Int {
        monthArr.removeAll()
        if year == currentYear {
            for idx in 1...currentMonth {
                monthArr.append(idx)
            }
        } else {
            for idx in 1...12 {
                monthArr.append(idx)
            }
        }
        if monthIndex > (monthArr.count - 1) {
            monthIndex = monthArr.count - 1
        }
        return monthArr.count
    }
    func p_getDaysFrom(year: Int, month: Int) -> Int {
        
        if year == currentYear, month == currentMonth {
            self.p_setDays(num: currentDay)
            return currentDay
        }
        
        var isLeapYear = false
        if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
            isLeapYear = true
        }
        switch (month) {
        case 1,3,5,7,8,10,12 :
            self.p_setDays(num: 31)
            return 31
        case 4,6,9,11 :
            self.p_setDays(num: 30)
            return 30
        case 2:
            let num = isLeapYear ? 29 : 28
            self.p_setDays(num: num)
            return num
        default:
            break
        }
        return 0
    }
    func p_actionTapGesture(tap: UITapGestureRecognizer) {
        self.hide()
    }
    func p_initSubviews() {
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(p_actionTapGesture(tap:))))
        
        containerView = UIView.init(frame: CGRect.init(x: 0, y: kScreenHei() - kFitCeilWid(250), width: kScreenWid(), height: kFitCeilWid(250)))
        containerView.backgroundColor = UIColor.white
        self.addSubview(containerView)
        
        titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWid(), height: kFitCeilWid(40)))
        titleLabel.backgroundColor = UIColor.white
        titleLabel.font = kRegularFitFont(size: 13)
        titleLabel.textColor = kMidTitleColor()
        titleLabel.textAlignment = .center
        titleLabel.text = "请选择时间"
        containerView.addSubview(titleLabel)
        
        let line = UIView.init(frame: CGRect.init(x: 0, y: titleLabel.bottom - 0.5, width: titleLabel.width, height: 5))
        line.backgroundColor = kSeparateLineColor()
        containerView.addSubview(line)
        
        doneBtn = LYFrameButton.init(frame: CGRect.init(x: 0, y: containerView.height - kFitCeilWid(40), width: kScreenWid(), height: kFitCeilWid(40)))
        doneBtn.backgroundColor = kThemeColor()
        doneBtn.titleLabel?.font = kRegularFitFont(size: 16)
        doneBtn.titleLabel?.textAlignment = .center
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.setTitleColor(UIColor.white, for: .normal)
        doneBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .highlighted)
        doneBtn.isAlphaHalfWhenHlight = true
        doneBtn.addTarget(self, action: #selector(p_actionDoneBtn), for: .touchUpInside)
        containerView.addSubview(doneBtn)
        
        dateView = UIView.init(frame: CGRect.init(x: 0, y: titleLabel.bottom, width: kScreenWid(), height: containerView.height - titleLabel.height - doneBtn.height))
        dateView.backgroundColor = UIColor.white
        containerView.addSubview(dateView)
        
        datePicker = UIPickerView.init(frame: dateView.bounds)
        datePicker.showsSelectionIndicator = false
        datePicker.delegate = self
        datePicker.dataSource = self
        dateView.addSubview(datePicker)
        
        self.p_setUpConfig()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

