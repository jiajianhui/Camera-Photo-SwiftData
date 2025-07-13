//
//  CameraPermission.swift
//  Camera Photo SwiftData
//
//  Created by 贾建辉 on 2025/7/13.
//

import UIKit
import AVFoundation

enum CameraPermission {
    
    // 相机错误枚举
    enum CameraError: Error, LocalizedError {
        
        // 两种情况，未授权、设备不可用
        case unauthorized
        case unavailable
        
        // 计算属性，错误描述
        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return NSLocalizedString("没有权限", comment: "")
            case .unavailable:
                return NSLocalizedString("设备不可用", comment: "")
            }
        }
        
        // 计算属性，建议操作
        var recoverySuggestion: String? {
            switch self {
            case .unauthorized:
                return "在系统设置中开启"
            case .unavailable:
                return "使用图库照片"
            }
        }
    }
    
    // 权限检查函数
    static func checkPermission() -> CameraError? {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .notDetermined:
                return  nil
            case .restricted:
                return  nil
            case .denied:
                return .unauthorized
            case .authorized:
                return  nil
            @unknown default:
                return  nil
            }
        } else {
            return .unavailable
        }
    }
}
