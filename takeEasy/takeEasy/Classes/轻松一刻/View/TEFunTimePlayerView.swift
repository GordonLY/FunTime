//
//  TEFunTimePlayerView.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/5.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import Kingfisher

class TEFunTimePlayerView: UIView {

    var funTimeModel = TEFunTimeListModel() {
        didSet {
            
            guard let imgUrl = URL.init(string: funTimeModel.imgsrc) else {
                d_print("imgSrc is illegal")
                return
            }
            bgImgView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, progressBlock: nil) { [weak self](image, error, url, data) in
                if error == nil {
                    self?.bgImgView.image = image?.blur()
                    self?.effectView.removeFromSuperview()
                }
            }
        }
    }
    private var bgImgView: UIImageView!
    private var effectView: UIVisualEffectView!
    private var playBgView: UIImageView!
    private var playBtn: LYFrameButton!
    private var downloadBtn: UIButton!
    
    // MARK: - ********* Actions
    func p_actionPlayBtn() {
        
        
        
    }
    func p_actionDownloadBtn() {
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ly_size = CGSize.init(width: kScreenWid(), height: kFitCeilWid(188))
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        
        bgImgView = UIImageView.init(frame: self.bounds)
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.image = UIImage.init(named: "ft_play_bg")
        self.addSubview(bgImgView)
        let effect = UIBlurEffect.init(style: .light)
        effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = bgImgView.bounds
        bgImgView.addSubview(effectView)
        
        let bgPlay = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kFitCeilWid(116), height: kFitCeilWid(116)))
        bgPlay.layer.ly.setRoundRect()
        bgPlay.center = CGPoint.init(x: self.middleX, y: self.middleY - kFitCeilWid(5))
        bgPlay.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        self.addSubview(bgPlay)
        
        playBgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kFitCeilWid(105), height: kFitCeilWid(105)))
        playBgView.center = bgPlay.center
        playBgView.contentMode = .scaleAspectFill
        playBgView.image = UIImage.init(named: "ft_play_cover")
        playBgView.layer.ly.setRoundRect()
        self.addSubview(playBgView)
        
        playBtn = LYFrameButton.init(frame: playBgView.frame)
        playBtn.layer.ly.setRoundRect()
        playBtn.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        playBtn.setImage(UIImage.init(named: "ft_palyer_play")?.ly_image(tintColor: UIColor.init(white: 1, alpha: 0.8)), for: .normal)
        playBtn.setImage(UIImage.init(named: "ft_palyer_pause")?.ly_image(tintColor: UIColor.init(white: 1, alpha: 0.8)), for: .selected)
        playBtn.addTarget(self, action: #selector(p_actionPlayBtn), for: .touchUpInside)
        self.addSubview(playBtn)
        
        
        let sliderView = LYPlaySlider.init(frame: CGRect.init(x: kFitCeilWid(20), y: self.height - kFitCeilWid(25), width: self.width - kFitCeilWid(40), height: kFitCeilWid(25)))
        self.addSubview(sliderView)
        
        
        downloadBtn = UIButton.init(frame: CGRect.init(x: self.width - kFitCeilWid(50), y: 0, width: kFitCeilWid(50), height: kFitCeilWid(50)))
        downloadBtn.imageView?.contentMode = .center
        downloadBtn.setImage(nil, for: .disabled)
        downloadBtn.addTarget(self, action: #selector(p_actionDownloadBtn), for: .touchUpInside)
        self.addSubview(downloadBtn)
        
        let circle = LYCircleProgressView.init(frame: CGRect.init(x: 0, y: 0, width: kFitCeilWid(35), height: kFitCeilWid(35)))
        circle.center = downloadBtn.b_center
        circle.isUserInteractionEnabled = false
        downloadBtn.addSubview(circle)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            circle.progress = 0.3
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            circle.progress = 0.4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            circle.progress = 0.6
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            circle.progress = 0.8
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
            circle.progress = 0.92
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            circle.progress = 1
        }
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
