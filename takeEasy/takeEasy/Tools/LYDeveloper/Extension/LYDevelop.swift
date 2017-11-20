//
//  LYDevelop.swift
//  takeEasy
//
//  Created by Gordon on 2017/8/3.
//  Copyright © 2017年 Gordon. All rights reserved.
//

import UIKit

public final class LYDevelop<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol LYDevelopCompatible {
    associatedtype LYCompatibleType
    var ly: LYCompatibleType { get }
}

public extension LYDevelopCompatible {
    public var ly: LYDevelop<Self> {
        get { return LYDevelop(self) }
    }
}

extension UINavigationBar: LYDevelopCompatible { }
extension String: LYDevelopCompatible { }
extension CALayer: LYDevelopCompatible { }
extension TimeInterval: LYDevelopCompatible { }
extension Int: LYDevelopCompatible { }
extension UIImage: LYDevelopCompatible{ }

