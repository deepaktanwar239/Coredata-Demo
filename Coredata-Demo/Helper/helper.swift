//
//  helper.swift
//  Coredata-Demo
//
//  Created by Deepak Tanwar on 07/06/23.
//

import Foundation
import UIKit

class Helper {
    public static var Shared : Helper  = Helper()
    
    private init(){}
    
   public func fetchImageFromDocumentDiretory(imageName : String?) -> UIImage?{
       
       guard let imageName = imageName else{ return nil}
       
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL  = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName)
            
            guard let image =  UIImage(contentsOfFile: imageURL.path) else{
                return nil
            }
            return image
        }
        return nil
    }
    
    
}
