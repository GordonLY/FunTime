//
//  AppDelegate.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        p_initWindow()
        p_initBugly()
        
        return true
    }
    
    // MARK: - ********* 远程控制 remote control
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            var type = UIEventSubtype.none
            switch event!.subtype {
            case .remoteControlPlay :
                type = .remoteControlPlay
            case .remoteControlPause :
                type = .remoteControlPause
            case .remoteControlNextTrack :
                type = .remoteControlNextTrack
            case .remoteControlPreviousTrack:
                type = .remoteControlPreviousTrack
            case .remoteControlTogglePlayPause:
                type = .remoteControlTogglePlayPause
            default:
                break
            }
            let info = ["type": type]
            NotificationCenter.default.post(name:.ly_AppDidReceiveRemoteControlNotification, object: nil, userInfo: info)
        }
    }
}

extension AppDelegate {
    // MARK: === init Window
    fileprivate func p_initWindow() {
        if window == nil {
            window = UIWindow.init(frame: UIScreen.main.bounds)
            let homeVc = TEFunTimeVC()
            let rootVc = LYNavigationController.init(rootViewController: homeVc)
            window!.rootViewController = rootVc
            window!.makeKeyAndVisible()
        }
    }
    // MARK: === third libs
    /// Bugly
    fileprivate func p_initBugly() {
        let config = BuglyConfig()
        config.channel = "takeEasy--iOS"
        config.version = "v1.1.0"
        config.deviceIdentifier = LYDeviceInfo.getPhoneName() + LYDeviceInfo.getPhoneNickName() + LYDeviceInfo.getSystemVersion() + LYDeviceInfo.getIPAddress()
        Bugly.start(withAppId: "af90d8983b", developmentDevice: false, config: config)
    }
}

