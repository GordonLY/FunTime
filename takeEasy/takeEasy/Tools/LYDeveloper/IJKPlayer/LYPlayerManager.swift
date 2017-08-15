//
//  LYPlayerManager.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/10.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit
import IJKMediaFramework

enum LYPlayeState {
    case stop
    case connecting
    case prepareToPlay
    case playing
    case pause
    case failed
    case done
}

class LYPlayerManager: UIResponder  {

    // MARK: - ********* public properties
    /// totalTime ,currentTime , currentPercent , playablePercent
    var playTimeChanged: ((TimeInterval, TimeInterval, CGFloat, CGFloat) -> Void)?
    /// state , totalTime
    var playStateChanged: ((LYPlayeState) -> Void)?
    static let shared = LYPlayerManager()
    private override init() {
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(p_updateTime), userInfo: nil, repeats: true)
        timer.fireDate = Date.distantFuture
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    var state = LYPlayeState.stop
    var model = LYPlayerModel() {
        didSet {
            self.stop()
            self.p_resetPlayer()
        }
    }
    
    let playOption = LYPlayerOption()
    
    private var player: IJKFFMoviePlayerController?
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
        UIApplication.shared.isIdleTimerDisabled = false
        self.p_updateInfoCenter()
    }
    var currentPlayTimePercent:TimeInterval = 0 {
        didSet {
            guard let _ = player else {
                return
            }
            timer.fireDate = Date.distantFuture
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(p_setCurrentPlaybackTime), with: nil, afterDelay: 0.3)
        }
    }
    func p_setCurrentPlaybackTime() {
        guard let play = player else {
            return
        }
        play.currentPlaybackTime = play.duration * currentPlayTimePercent
    }
    func pause() {
        guard let play = player else {
            return
        }
        state = .pause
        play.pause()
        self.p_updateInfoCenter()
    }
    func stop() {
        guard let play = player else {
            return
        }
        state = .stop
        play.stop()
        self.p_resetPlayer()
        self.p_updateInfoCenter()
        
    }

    // MARK: === 重新构建 player
    func p_resetPlayer() {
        if let url = model.url {
            playOption.currenTime = 0
            playOption.totalTime = 0
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
            playOption.totalTime = play.duration
            let total = CGFloat(play.duration)
            let curr_per = CGFloat(play.currentPlaybackTime) / total
            let able_per = CGFloat(play.playableDuration) / total
            timeChanged(playOption.totalTime,playOption.currenTime,curr_per,able_per)
        }
    }
    // MARK: === 更新 info center
    func p_updateInfoCenter() {
        var nowInfo = [String: Any]()
        nowInfo[MPMediaItemPropertyTitle] = model.title
        nowInfo[MPMediaItemPropertyArtist] = model.artist
        if model.cover_img != nil {
            nowInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(image: model.cover_img!)
        }
        nowInfo[MPMediaItemPropertyPlaybackDuration] = playOption.totalTime
        nowInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playOption.currenTime
        nowInfo[MPMediaItemPropertyMediaType] = MPMediaType.anyAudio.rawValue
        if state == .playing {
            nowInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        } else {
            nowInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowInfo
    }
    // MARK: - ********* remote Control
    func p_remoteControlReceived(noti: Notification) {
        guard let info = noti.userInfo as? [String: UIEventSubtype],
                let type = info["type"] else {
            return
        }
        switch type {
        case .remoteControlPlay :
            self.start()
        case .remoteControlPause :
            self.pause()
        case .remoteControlNextTrack :
            //                jukebox.playNext()
            break
        case .remoteControlPreviousTrack:
            //                jukebox.playPrevious()
            break
        case .remoteControlTogglePlayPause:
            if state == .playing {
                self.pause()
            } else {
                self.start()
            }
        default:
            break
        }
        self.p_updateInfoCenter()
    }
    // MARK: - ********* IJKPlayer 监听相关方法
    // MARK: === 加载状态改变
    ///  Posted when the network load state changes.
    func p_loadStateChanged(noti: Notification) {
        guard let play = player,
                let stateChanged = playStateChanged else {
            return
        }
        playOption.totalTime = play.duration
        switch play.loadState {
        case [.playthroughOK]:
            // Playback will be automatically started in this state when shouldAutoplay is YES
            state = .prepareToPlay
            stateChanged(state)
        case [.stalled]:
            // Playback will be automatically paused in this state, if started
            state = .pause
            stateChanged(state)
        case [.playable,.playthroughOK]:
            state = .prepareToPlay
            stateChanged(state)
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
        guard let stateChanged = playStateChanged,
            let reason = noti.userInfo?[IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as? NSNumber,
            let finishReason = IJKMPMovieFinishReason.init(rawValue: reason.intValue) else {
            return
        }
        
        switch finishReason {
        case .playbackEnded:    // 播放完成
            state = .done
        case .userExited:       // 用户退出
            state = .failed
        case .playbackError:    // 播放错误
            state = .failed
        }
        playOption.currenTime = 0
        playOption.totalTime = 0
        stateChanged(state)
        self.stop()
    }
    // MARK: - ********* 添加监听 IJKPlayer notification
    func p_registerIJKPlayerNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(p_loadStateChanged(noti:)), name: .IJKMPMoviePlayerLoadStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(p_isPreparedToPlay(noti:)), name: .IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(p_playStateChanged(noti:)), name: .IJKMPMoviePlayerPlaybackStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(p_playFinishStateChanged(noti:)), name: .IJKMPMoviePlayerPlaybackDidFinish, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(p_remoteControlReceived(noti:)), name: .ly_AppDidReceiveRemoteControlNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.endReceivingRemoteControlEvents()
        timer.invalidate()
        if let play = player {
            play.shutdown()
        }
    }
}


