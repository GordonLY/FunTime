//
//  LYPlayerManager.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/10.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import IJKMediaFramework

class LYPlayerManager: NSObject {

    // MARK: - ********* public properties
    /// currentTime , currentPercent , playablePercent
    var playTimeChanged: ((String, CGFloat, CGFloat) -> Void)?
    /// state , totalTime
    var playStateChanged: ((LYPlayeState, String) -> Void)?
    static let shared = LYPlayerManager()
    private override init() {
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(p_updateTime), userInfo: nil, repeats: true)
    }
    enum LYPlayeState {
        case stop
        case connecting
        case playing
        case pause
        case failed
    }
    var state = LYPlayeState.stop
    var playUrl: URL? {
        didSet {
            self.stop()
            self.p_resetPlayer()
        }
    }
    
    private var player: IJKFFMoviePlayerController?
    private let playOption = LYPlayerOption()
    private var timer: Timer!
    
    // MARK: - ********* play action
    func start() {
        guard let play = player else {
            return
        }
        if play.isPreparedToPlay {
            play.play()
        } else {
            play.prepareToPlay()
        }
        state = .playing
    }
    func start(atPercent percent: CGFloat) {
        guard let play = player else {
            return
        }
        timer.fireDate = Date.distantFuture
        play.currentPlaybackTime = play.duration * TimeInterval(percent)
    }
    func pause() {
        guard let play = player else {
            return
        }
        play.pause()
        state = .pause
    }
    func stop() {
        guard let play = player else {
            return
        }
        play.stop()
        state = .stop
        self.p_resetPlayer()
        
    }
    // MARK: === 重新构建 player
    func p_resetPlayer() {
        if let url = playUrl {
            let options = IJKFFOptions.byDefault()
            player = IJKFFMoviePlayerController.init(contentURL: url, with: options)
            player?.shouldAutoplay = true
            NotificationCenter.default.removeObserver(self)
            self.p_registerIJKPlayerNoti()
        }
    }
 
    
    // MARK: === 更新时间（每秒钟更新一次）
    func p_updateTime() {
        if let play = player, play.isPlaying(),
            let timeChanged = playTimeChanged {
            
            playOption.currenTime = play.currentPlaybackTime
            let curr_str = play.currentPlaybackTime.ly.toTimeString()
            let total = CGFloat(play.duration)
            let curr_per = CGFloat(play.currentPlaybackTime) / total
            let able_per = CGFloat(play.playableDuration) / total
            timeChanged(curr_str,curr_per,able_per)
        }
    }
    
    // MARK: - ********* IJKPlayer 监听相关方法
    // MARK: === 加载状态改变
    ///  Posted when the network load state changes.
    func p_loadStateChanged(noti: Notification) {
        guard let play = player,
                let stateChanged = playStateChanged else {
            return
        }
        switch play.loadState {
        case [.playthroughOK]:
            // Playback will be automatically started in this state when shouldAutoplay is YES
            state = .playing
            stateChanged(state, play.duration.ly.toTimeString())
        case [.stalled]:
            // Playback will be automatically paused in this state, if started
            state = .pause
            stateChanged(state, play.duration.ly.toTimeString())
        case [.playable,.playthroughOK]:
            state = .playing
            stateChanged(state, play.duration.ly.toTimeString())
        default:
            break
        }
    }
    // MARK: === IsPreparedToPlay
    /// Posted when the prepared state changes of an object conforming to the MPMediaPlayback protocol changes.
    func p_isPreparedToPlay(noti: Notification) {
        d_print("=== noti : isPreparedToPlay")
    }
    // MARK: === 播放状态改变
    /// Posted when the playback state changes, either programatically or by the user.
    func p_playStateChanged(noti: Notification) {
        guard let play = player else {
                return
        }
        switch play.playbackState {
        case .stopped:
            timer.fireDate = Date.distantFuture
        case .paused:
            timer.fireDate = Date.distantFuture
        case .interrupted:
            timer.fireDate = Date.distantFuture
        case .playing:
            timer.fireDate = Date.distantPast
        case .seekingBackward:
            timer.fireDate = Date.distantPast
        case .seekingForward:
            timer.fireDate = Date.distantPast
        }
    }
    // MARK: === 播放完成状态改变
    /// Posted when movie playback ends or a user exits playback.
    func p_playFinishStateChanged(noti: Notification) {
        d_print("=== noti : PlayBackFinish")
    }
    // MARK: - ********* 添加监听 IJKPlayer notification
    func p_registerIJKPlayerNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(p_loadStateChanged(noti:)), name: .IJKMPMoviePlayerLoadStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(p_isPreparedToPlay(noti:)), name: .IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(p_playStateChanged(noti:)), name: .IJKMPMoviePlayerPlaybackStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(p_playFinishStateChanged(noti:)), name: .IJKMPMoviePlayerPlaybackDidFinish, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
}


