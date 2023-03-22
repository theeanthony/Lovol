//
//  CompressorClass.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/21/23.
//

import AVFoundation




class VideoCompressor {
    
    func compressVideo(inputURL: URL, handler: @escaping (Result<URL, Error>) -> Void) {
        
        let asset = AVAsset(url: inputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(.failure(VideoCompressorError.invalidExportSession))
            return
        }
        
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        let compressedURL = URL(fileURLWithPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
        
        exportSession.outputURL = compressedURL
        
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .completed:
                handler(.success(compressedURL))
            case .failed:
                handler(.failure(exportSession.error ?? VideoCompressorError.unknownError))
            case .cancelled:
                handler(.failure(VideoCompressorError.exportSessionCancelled))
            default:
                handler(.failure(VideoCompressorError.unknownError))
            }
        })
    }
}


enum VideoCompressorError: Error {
    case invalidExportSession
    case exportSessionCancelled
    case dataConversionFailed
    case unknownError
}
