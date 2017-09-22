//
//  LYSwiftMacro.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/2.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

// MARK: - ****** iPhone x nav适配 ******
func kNavBottom() -> CGFloat {
    if isIphoneX() {
        return 88
    }
    return 64
}
func kNavTop() -> CGFloat {
    if isIphoneX() {
        return 44
    }
    return 20
}
func kBtmSafeHei() -> CGFloat {
    if isIphoneX() {
        return 34
    }
    return 0
}
func isIphoneX() -> Bool {
    if LYDevelopExtern.shared.lyScreenHeight == 812 {
        return true
    }
    return false
}

// MARK: - ****** 尺寸相关 ******
// frame
func kFitWid(_ wid:CGFloat) -> CGFloat {
    return LYDevelopExtern.shared.lyScreenWidthRatio * wid
}
func kFitCeilWid(_ wid:CGFloat) -> CGFloat {
    return CGFloat(ceilf(Float(LYDevelopExtern.shared.lyScreenWidthRatio * wid)))
}
func kFitFloorWid(_ wid:CGFloat) -> CGFloat {
    return CGFloat(floorf(Float(LYDevelopExtern.shared.lyScreenWidthRatio * wid)))
}

func kFitHei(_ Hei:CGFloat) -> CGFloat {
    return LYDevelopExtern.shared.lyScreenHeightRatio * Hei
}
func kFitCeilHei(_ Hei:CGFloat) -> CGFloat {
    return CGFloat(ceilf(Float(LYDevelopExtern.shared.lyScreenHeightRatio * Hei)))
}
func kFitFloorHei(_ Hei:CGFloat) -> CGFloat {
    return CGFloat(floorf(Float(LYDevelopExtern.shared.lyScreenHeightRatio * Hei)))
}
func kScreenWid() -> CGFloat {
    return LYDevelopExtern.shared.lyScreenWidth
}
func kScreenHei() -> CGFloat {
    return LYDevelopExtern.shared.lyScreenHeight
}

// MARK: - ****** 字体相关 ******
// font
func kRegularFitFont(size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: kFitWid(size))
}
func kBoldFitFont(size:CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: kFitWid(size))
}
func kNumberFont(size:CGFloat) -> UIFont {
    return UIFont.init(name: "ReznorDownwardSpiral", size: kFitWid(size)) ?? kRegularFitFont(size: size)
}
func kStandardRegualrFont(size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}
func kNaviFont() -> UIFont {
    return UIFont.systemFont(ofSize: 18)
}
func kNaviBtnFont() -> UIFont {
    return UIFont.systemFont(ofSize: 15)
}

// MARK: - ****** 颜色相关 ******
// color
func kThemeColor() -> UIColor {
    return UIColor.ly_color(0xff5722)
}
func kThemeColorHalf() -> UIColor {
    return UIColor.ly_color(0xfe5722, 0.5)
}
func kSeparateLineColor() -> UIColor {
    return UIColor.ly_color(0xdddddd, 1)
}
func kPlaceholderColor() -> UIColor {
    return UIColor.ly_color(0xf4f4f4, 1)
}
func kBgColorF5() -> UIColor {
    return UIColor.ly_color(0xf5f5f5, 1)
}
func kDisableColor() -> UIColor {
    return UIColor.gray
}

func kMaleColor() -> UIColor {
    return UIColor.ly_color(0x75aaf2)
}
func kFemaleColor() -> UIColor {
    return UIColor.ly_color(0xf8537a)
}

/**  主标题颜色 - 黑  */
func kTitleColor() -> UIColor {
    return UIColor.ly_color(0x333333, 1)
}
func kTitleColorHalf() -> UIColor {
    return UIColor.ly_color(0x333333, 0.5)
}
/**  次标题颜色 - 黑  */
func kMidTitleColor() -> UIColor {
    return UIColor.ly_color(0x666666, 1)
}
func kMidTitleColorHalf() -> UIColor {
    return UIColor.ly_color(0x666666, 0.5)
}
/**  副标题颜色 - 淡灰  */
func kSubTitleColor() -> UIColor {
    return UIColor.ly_color(0x999999, 1)
}
func kSubTitleColorHalf() -> UIColor {
    return UIColor.ly_color(0x999999, 0.5)
}

// MARK: - ****** placeHolder ******
// 无数据图片
func kNoDataTipImage() -> UIImage {
    return UIImage.init(named: "jz_search_noResult")!
}
// 默认头像
func kCustomDefaultImg() -> UIImage {
    return UIImage.init(named: "jz_custom_photoPlaceholder")!
}
// 男性头像
func kCustomMaleImg() -> UIImage {
    return UIImage.init(named: "jz_custom_malePhoto")!
}
// 女性头像
func kCustomFemaleImg() -> UIImage {
    return UIImage.init(named: "jz_custom_femalePhoto")!
}

// MARK: - ****** 其他 ******
// MARK: === ScrollIndicator 永远显示
let ly_alwaysShowScrollIndicator = 654321

