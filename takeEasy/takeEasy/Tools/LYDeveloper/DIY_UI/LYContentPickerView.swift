//
//  LYContentPickerView.swift
//  i行销
//
//  Created by Gordon on 2017/7/4.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

import UIKit

class LYContentPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var contentArr = [String]() {
        didSet {
            contentPicker.reloadAllComponents()
        }
    }
    var titleLabel: UILabel!
    var doneBtn:    LYFrameButton!
    var selectCallBack: ((String) -> Void)?
    
    private var seletedStr = ""
    
    private var containerView: UIView!
    private var bgView:   UIView!
    private var contentPicker: UIPickerView!
    
    
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
    func ly_setSelectedDate(_ date: String?) {
        guard contentArr.count > 0 else {
            contentArr = [""]
            return
        }
        let idx = contentArr.index(of: date ?? "") ?? 0
        contentPicker.selectRow(idx, inComponent: 0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let label = self.contentPicker.view(forRow: idx, forComponent: 0) as? UILabel {
                label.textColor = kThemeColor()
            }
        }
        seletedStr = contentArr[idx]
    }
    
    
    // MARK: - ********* UIPickerView delegate and dataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contentArr.count
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
        label.text = contentArr[row]
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        seletedStr = contentArr[row]
        let view = pickerView.view(forRow: row, forComponent: component)
        if let label = view as? UILabel {
            label.textColor = kThemeColor()
        }
    }
    
    // MARK: - ********* Private Method
    @objc func p_actionDoneBtn() {
        self.hide()
        if let callBack = selectCallBack {
            callBack(seletedStr)
        }
    }
    
    @objc func p_actionTapGesture(tap: UITapGestureRecognizer) {
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
        doneBtn.isAlphaHalfWhenHlight = true
        doneBtn.addTarget(self, action: #selector(p_actionDoneBtn), for: .touchUpInside)
        containerView.addSubview(doneBtn)
        
        bgView = UIView.init(frame: CGRect.init(x: 0, y: titleLabel.bottom, width: kScreenWid(), height: containerView.height - titleLabel.height - doneBtn.height))
        bgView.backgroundColor = UIColor.white
        containerView.addSubview(bgView)
        
        contentPicker = UIPickerView.init(frame: bgView.bounds)
        contentPicker.showsSelectionIndicator = false
        contentPicker.delegate = self
        contentPicker.dataSource = self
        bgView.addSubview(contentPicker)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
