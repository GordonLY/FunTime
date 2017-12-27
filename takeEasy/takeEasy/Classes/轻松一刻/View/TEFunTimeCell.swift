//
//  TEFunTimeCell.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import Hero

class TEFunTimeCell: UITableViewCell {

    var data = TETimeListData() {
        didSet {
            titleLabel?.text = data.title
            titleLabel.sizeToFit()
            imgView.ly.setImage(with: URL.init(string: data.imgsrc), cornerRadius: kFitWid(10))
            dateLabel.text = data.time_show
        }
    }
    
    var imgView: UIImageView!
    var titleLabel: UILabel!
    private var dateLabel: UILabel!
    
    static let CellReuseId = "TEFunTimeCell"
    class func cellWithTableView(_ tableView: UITableView, indexPath: IndexPath) -> TEFunTimeCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId, for: indexPath) as? TEFunTimeCell else {
            return TEFunTimeCell(style: .default, reuseIdentifier: CellReuseId)
        }
        return cell
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        
        imgView = UIImageView.init(frame: CGRect.init(x: kFitCeilWid(10), y: kFitCeilWid(8), width: kFitCeilWid(100), height: kFitCeilWid(75)))
        imgView.clipsToBounds = true
        imgView?.contentMode = .scaleAspectFill
        imgView?.backgroundColor = UIColor.white
        contentView.addSubview(imgView)
        
        titleLabel = UILabel.init(frame: CGRect.init(x: imgView.right + kFitCeilWid(8), y: imgView.top, width: kScreenWid() - kFitCeilWid(130), height: kFitCeilWid(40)))
        titleLabel.font = kRegularFitFont(size: 15)
        titleLabel.textColor = kTitleColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 3
        titleLabel.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        
        dateLabel = UILabel.init(frame: CGRect.init(x: titleLabel.left, y: imgView.bottom - kFitCeilWid(11), width: titleLabel.width - kFitCeilWid(10), height: kFitCeilWid(12)))
        dateLabel.font = kRegularFitFont(size: 11)
        dateLabel.textAlignment = .right
        dateLabel.textColor = kSubTitleColor()
        dateLabel.backgroundColor = UIColor.white
        contentView.addSubview(dateLabel)
        
        let line = UIView.init(frame: CGRect.init(x: imgView.left, y: kFitCeilWid(90) - 0.5, width: kScreenWid() - imgView.left, height: 0.5))
        line.backgroundColor = kSeparateLineColor()
        contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.frame = CGRect.init(x: imgView.right + kFitCeilWid(8), y: imgView.top, width: kScreenWid() - kFitCeilWid(130), height: kFitCeilWid(40))
    }
}
