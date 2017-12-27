//
//  LYDeviceInfo.h
//  takeEasy
//
//  Created by Gordon on 2017/12/26.
//  Copyright © 2017年 Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYDeviceInfo : NSObject

+ (NSString *)getSystemVersion;

+ (NSString *)getPhoneName;

+ (NSString *)getPhoneNickName;

+ (NSString *)getIDFA;

+ (BOOL)isIPad;

+ (NSString *)getIPAddress;

@end
