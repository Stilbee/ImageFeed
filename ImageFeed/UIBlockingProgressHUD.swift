//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Alibi on 12.10.2024.
//

import UIKit
import ProgressHUD

class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
