//
//  LYTextView.h
//  kemiBear
//
//  Created by 李扬 on 2017/3/6.
//  Copyright © 2017年 lanrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;


@end
