//
//  ScanAndPayViewModel.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import Foundation
import UIKit

class ScanAndPayViewModel {
    
    func generateQRCode(from string: String) -> UIImage? {
//        
//        let ID = ""
//        print("ID \(ID)")
        if let jsonData = try? JSONEncoder().encode(string) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("QRCode \(jsonString)")
                let data = jsonString.data(using: String.Encoding.ascii)
                
                if let filter = CIFilter(name: "CIQRCodeGenerator") {
                    filter.setValue(data, forKey: "inputMessage")
                    let transform = CGAffineTransform(scaleX: 3, y: 3)
                    
                    if let output = filter.outputImage?.transformed(by: transform) {
                        return UIImage(ciImage: output)
                    }
                }
            }
        }
        
        return nil
    }
    
}
