//
//  MusicModel.swift
//  file
//
//  Created by 翟泉 on 2016/10/9.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import CoreData


protocol MusicModelDelegate: NSObjectProtocol {
    func controller(_ controller: NSFetchedResultsController<Music>, didChange anObject: Music, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
}

class MusicModel: NSObject, NSFetchedResultsControllerDelegate {
    
    
    static var context = createMusicContext()
    
    class func list() -> [Music] {
        return share.musicList
    }
    
    @discardableResult
    class func newMusic(url: URL) -> Music {
        
        for music in list() {
            if music.url == url {
                music.playCount += 1
                try! context.save()
                return music
            }
        }
        
        guard let music = NSEntityDescription.insertNewObject(forEntityName: "Music", into: context) as? Music else {
            fatalError("Wrong object type")
        }
        
        music.setup(url: url)
        try! context.save()
        
        share.musicList.insert(music, at: 0)
        
        return music
    }
    
    class func deleteAll() {
        for music in list() {
            context.delete(music)
        }
        try! context.save()
    }
    
    class func cover(for url: URL) -> UIImage? {
        for music in list() {
            if music.url == url {
                return music.image
            }
        }
//        let music = Music()
//        music.setup(url: url)
//        return music.image
        return nil
    }
    
    
    private static var share = MusicModel()
    
    private var musicList = [Music]()
    
    private var fetchedResults: NSFetchedResultsController<Music>!
    
    private override init() {
        super.init()
        
        let request = NSFetchRequest<Music>(entityName: "Music")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//        request.fetchBatchSize = 10
        request.returnsObjectsAsFaults = false
        
        fetchedResults = NSFetchedResultsController<Music>(fetchRequest: request, managedObjectContext: MusicModel.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResults.delegate = self
        do {
            try fetchedResults.performFetch()
        }
        catch {
            print(error)
        }
        
        guard fetchedResults.fetchedObjects != nil else {
            return
        }
        musicList = fetchedResults.fetchedObjects!
        
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(#function)
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(#function)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        print(#function)
        return "AZUSA: \(sectionName)"
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print(#function, "\tIndex: \(indexPath)  newIndexPath: \(newIndexPath)  type: \(type)")
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        print(#function)
    }
    
    
}


extension NSFetchedResultsChangeType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .insert:
            return "insert"
        case .delete:
            return "delete"
        case .move:
            return "move"
        case .update:
            return "update"
        }
    }
}



// 存储的位置
private let StoreURL = NSURL.documentsURL.appendingPathComponent("Music")

public func createMusicContext() -> NSManagedObjectContext {
    // 获取托管对象模型所在的 bundle
    let bundle = Bundle(for: Music.classForCoder())
    // 加载数据模型
    guard let model = NSManagedObjectModel.mergedModel(from: [bundle]) else {
        fatalError("model not found")
    }
    // 持久化存储协调器
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: StoreURL, options: nil)
    // .MainQueueConcurrencyType 表示这个上下文是绑定到主线程的
    let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}


extension NSURL {
    
    static var documentsURL: NSURL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) as NSURL
    }
    
}

