//
//  UploadManager.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 8/10/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class UploadManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
 
    public static let shared = UploadManager()
    
    var showProgress: Bool
    var progress: Double {
        didSet{
            print("uploadProgress: \(self.progress * 100)%. progress:\(self.progress)")
            if showProgress {
                LoaderController.shared.progressCounter = self.progress
                if (self.progress == Constants.NumericConstants.DOUBLE_ONE) {
                    LoaderController.shared.removeProgressView()
                }
            }
        }
    }
    
    override init() {
        self.progress = Constants.NumericConstants.DOUBLE_ZERO
        self.showProgress = true
    }
    
    func showProgressView() {
        self.progress = Constants.NumericConstants.DOUBLE_ZERO
        if showProgress {
            LoaderController.shared.progressCounter = self.progress
            LoaderController.shared.startProgressView(progressViewStyle: .bar)
        }
    }
    
    func uploadFile(signedUploadUrl: URL, data: Data, completion : @escaping (_ result : Bool) -> Void) {
        print("uploadFile")
        self.showProgressView()
        
        var request = URLRequest(url: signedUploadUrl)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "PUT"
        let fileContentTypeStr = "image/jpg"
        request.setValue(fileContentTypeStr, forHTTPHeaderField: "Content-Type")
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.uploadTask(with: request, from: data) { (data, response, error) in
            print("Upload complated: \(String(describing: response))")
            
            guard error == nil && data != nil else {
                print("Error: \(String(describing: error))")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("Server error")
                    return
            }
            completion(true)
        }
        task.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        self.progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
    }
    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if (error != nil) {
//            print("Error occured: \(String(describing: error))")
//        } else {
//            print("No error didCompleteWithError")
//        }
//    }
    
    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//        print("session \(session) receive response \(response)")
//    }
    
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        print("Receive data: \(data)")
//    }
    
    
}
