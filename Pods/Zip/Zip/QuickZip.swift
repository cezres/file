//
//  QuickZip.swift
//  Zip
//
//  Created by Roy Marmelstein on 16/01/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

extension Zip {
    
    //MARK: Quick Unzip
    
    /**
     Quick unzip a file. Unzips to a new folder inside the app's documents folder with the zip file's name.
     
     - parameter path: Path of zipped file. NSURL.
     
     - throws: Error if unzipping fails or if file is not found. Can be printed with a description variable.
     
     - returns: NSURL of the destination folder.
     */
    public class func quickUnzipFile(path: NSURL) throws -> NSURL {
        return try quickUnzipFile(path: path, progress: nil)
    }
    
    /**
     Quick unzip a file. Unzips to a new folder inside the app's documents folder with the zip file's name.
     
     - parameter path: Path of zipped file. NSURL.
     - parameter progress: A progress closure called after unzipping each file in the archive. Double value betweem 0 and 1.
     
     - throws: Error if unzipping fails or if file is not found. Can be printed with a description variable.
     
     - notes: Supports implicit progress composition
     
     - returns: NSURL of the destination folder.
     */
    public class func quickUnzipFile(path: NSURL, progress: ((progress: Double) -> ())?) throws -> NSURL {
        let fileManager = FileManager.default()
        guard let fileExtension = path.pathExtension, let fileName = path.lastPathComponent else {
            throw ZipError.UnzipFail
        }
        let directoryName = fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
//        let directoryName = fileName.stringByReplacingOccurrencesOfString(".\(fileExtension)", withString: "")
        let documentsUrl = fileManager.urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)[0] as NSURL
        let destinationUrl = documentsUrl.appendingPathComponent(directoryName, isDirectory: true)
        try self.unzipFile(zipFilePath: path, destination: destinationUrl!, overwrite: true, password: nil, progress: progress)
        return destinationUrl!
    }
    
    //MARK: Quick Zip
    
    /**
     Quick zip files.
     
     - parameter paths: Array of NSURL filepaths.
     - parameter fileName: File name for the resulting zip file.
     
     - throws: Error if zipping fails.
     
     - notes: Supports implicit progress composition
     
     - returns: NSURL of the destination folder.
     */
    public class func quickZipFiles(paths: [NSURL], fileName: String) throws -> NSURL {
        return try quickZipFiles(paths: paths, fileName: fileName, progress: nil)
    }
    
    /**
     Quick zip files.
     
     - parameter paths: Array of NSURL filepaths.
     - parameter fileName: File name for the resulting zip file.
     - parameter progress: A progress closure called after unzipping each file in the archive. Double value betweem 0 and 1.
     
     - throws: Error if zipping fails.
     
     - notes: Supports implicit progress composition
     
     - returns: NSURL of the destination folder.
     */
    public class func quickZipFiles(paths: [NSURL], fileName: String, progress: ((progress: Double) -> ())?) throws -> NSURL {
        let fileManager = FileManager.default()
        let documentsUrl = fileManager.urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)[0] as NSURL
        let destinationUrl = documentsUrl.appendingPathComponent("\(fileName).zip")
        try self.zipFiles(paths: paths, zipFilePath: destinationUrl!, password: nil, progress: progress)
        return destinationUrl!
    }
    
    
}
