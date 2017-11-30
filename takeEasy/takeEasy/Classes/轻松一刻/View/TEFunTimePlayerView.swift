//
//  TEFunTimePlayerView.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/5.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import Kingfisher
import MediaPlayer

class TEFunTimePlayerView: UIView {

    var funTimeData = TETimeListData() {
        didSet {
            
            guard let imgUrl = URL.init(string: funTimeData.imgsrc) else {
                d_print("imgSrc is illegal")
                return
            }
            bgImgView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, progressBlock: nil) { [weak self](image, error, url, data) in
                if error == nil {
                    self?.coverImg = image
                    self?.bgImgView.image = image?.blur()
                    self?.effectView.removeFromSuperview()
                }
            }
        }
    }
    var detailModel = TEFunTimDetailModel() {
        didSet {
            guard let url = detailModel.mp3Url else {
                return
            }
            if detailModel.isDownload {
                self.downloadBtn.isUserInteractionEnabled = false
                self.downloadBtn.isSelected = true
                self.circleProgress.isHidden = true
            }
            let model = LYPlayerModel()
            model.cover_img = coverImg
            model.title = funTimeData.title
            model.artist = funTimeData.source
            model.url = url
            player.model = model
        }
    }

    private let player = LYPlayerManager.shared
    private var coverImg: UIImage?
    private var bgImgView: UIImageView!
    private var effectView: UIVisualEffectView!
    private var playBgView: UIImageView!
    private var playBtn: LYFrameButton!
    private var downloadBtn: LYFrameButton!
    private var circleProgress: LYCircleProgressView!
    private var sliderView: LYPlaySlider!
    // MARK: - ********* Actions
    // MARK: - ********* 点击播放/暂停
    @objc func p_actionPlayBtn() {
        if detailModel.url_m3u8 == "" { return }
        playBtn.isSelected = !playBtn.isSelected
        if playBtn.isSelected {
            playBgView.layer.ly.start360Rotate(duration: 12, repeatCount: MAXFLOAT)
            player.start()
        } else {
            playBgView.layer.ly.pause360Rotate()
            player.pause()
        }
    }
    // MARK: - ********* 点击下载
    @objc func p_actionDownloadBtn() {
        
        if detailModel.url_m3u8 == "" { return }
        downloadBtn.isUserInteractionEnabled = false
        downloadBtn.setImage(nil, for: .normal)
        circleProgress.isHidden = false
        self.p_actionStartDownload()
    }
    // MARK: === 开始下载
    func p_actionStartDownload() {
        
        LYNetWorkRequest.ly_downloadFile(atPath: detailModel.url_m3u8, downProgress: { [weak self](progress, fileName) in
            self?.circleProgress.progress = progress.percent
        }) { [weak self](fileUrl) in
            self?.circleProgress.progress = 1
            self?.downloadBtn.isSelected = true
            self?.circleProgress.isHidden = true
            self?.detailModel.mp3Url = fileUrl
        }
    }
    // MARK: === 播放器状态 改变
    func p_playerStateChanged(state: LYPlayeState) {
        
        switch state {
        case .connecting:
            break
        case .pause:
            break
        case .prepareToPlay:
            sliderView.setTotalTime(player.playOption.totalTime.ly.toTimeString())
        case .playing:
            break
        case .stop:
            break
        case .failed, .done:
            self.p_actionPlayBtn()
            playBgView.layer.ly.stopRotate360()
            self.p_playerTimeChanged(totalTime: 0, currTime: player.playOption.currenTime, currTime_per: 0, playable_per: 0)
        }
    }
    // MARK: === 播放器时间 改变
    func p_playerTimeChanged(totalTime: TimeInterval, currTime: TimeInterval, currTime_per: CGFloat, playable_per: CGFloat) {
        if totalTime >= currTime {
            sliderView.setCurrentTime(currTime.ly.toTimeString())
            sliderView.setCurrent(currTime_per)
            sliderView.setPlayable(playable_per)
        }
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
        
        
        sliderView = LYPlaySlider.init(frame: CGRect.init(x: kFitCeilWid(20), y: self.height - kFitCeilWid(25), width: self.width - kFitCeilWid(40), height: kFitCeilWid(25)))
        self.addSubview(sliderView)
        sliderView.valueChanged = { [weak self] (percent) in
            self?.player.currentPlayTimePercent = TimeInterval(percent)
            
        }
        player.playStateChanged = { [weak self] (state) in
            self?.p_playerStateChanged(state: state)
        }
        player.playTimeChanged = { [weak self] (totalTime, curr_time, curr_per, playable_per) in
            self?.p_playerTimeChanged(totalTime: totalTime, currTime: curr_time,  currTime_per: curr_per, playable_per: playable_per)
        }
        
        downloadBtn = LYFrameButton.init(frame: CGRect.init(x: self.width - kFitCeilWid(44), y: 0, width: kFitCeilWid(44), height: kFitCeilWid(44)))
        downloadBtn.lyImageViewFrame = downloadBtn.bounds
        downloadBtn.imageView?.contentMode = .center
        downloadBtn.setImage(UIImage.init(named: "ft_play_download")?.ly_image(tintColor: UIColor.init(white: 1, alpha: 0.8)), for: .normal)
        downloadBtn.setImage(UIImage.init(named: "ft_play_havDownload")?.ly_image(tintColor: UIColor.init(white: 1, alpha: 0.8)), for: .selected)
        downloadBtn.addTarget(self, action: #selector(p_actionDownloadBtn), for: .touchUpInside)
        self.addSubview(downloadBtn)
        
        circleProgress = LYCircleProgressView.init(frame: CGRect.init(x: 0, y: 0, width: kFitCeilWid(34), height: kFitCeilWid(34)))
        circleProgress.center = downloadBtn.b_center
        circleProgress.isUserInteractionEnabled = false
        downloadBtn.addSubview(circleProgress)
        circleProgress.isHidden = true
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
