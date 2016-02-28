//
//  FileUtility.swift
//  Chat
//
//  Created by Cloudkibo on 23/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation

class FileUtility{
    
    var chunkSize:Int=16000
    var chunks_per_ack:Int=16
    let fm = NSFileManager.defaultManager()
    
    
    //credit:http://stackoverflow.com/questions/5712527/how-to-detect-total-available-free-disk-space-on-the-iphone-ipad-device
   
    func getfreeDiskSpace()->UInt64
    {
        var dictionary:[String:AnyObject]=["":""]
        var totalspace:UInt64=0
        var totalFreeSpace:UInt64=0
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        do
            {
                dictionary = try NSFileManager.defaultManager().attributesOfFileSystemForPath(paths.last!)
            }
        catch
            {   print("error")
                print(dictionary)
            }
        if(dictionary.count>0)
        {
            //for items in dictionary.keys
            //{
            var fileSystemSizeInBytes:NSNumber = dictionary["\(NSFileSystemSize)"] as! NSNumber
            var freeFileSystemSizeInBytes:NSNumber = dictionary["\(NSFileSystemFreeSize)"] as! NSNumber
            print("filesystem size is \(fileSystemSizeInBytes)")
            print("filesystemfree size is \(freeFileSystemSizeInBytes)")
            totalspace=fileSystemSizeInBytes.unsignedLongLongValue
            totalFreeSpace=freeFileSystemSizeInBytes.unsignedLongLongValue
            print("total space is \(totalspace/1024)")
            print("total free space is \(totalFreeSpace/1024)")
            //}
            
        }
        else
        {
            print("Error in getting free disk space")
        }
        return totalFreeSpace
    }
    
    func isFreeSpacAvailable(var fileSize:Int)->Bool
    {
        var totalfreespace=getfreeDiskSpace()
        var test=UInt64(10000000)
        var x=totalfreespace-test
        if(totalfreespace > UInt64(fileSize))
        {
            print("free space available")
            return true
            
        }
        else
        {
            print("free space not available")
            return false
        }
    }
    
    //let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
   // let docsDir1 = dirPaths[0]
    //var documentDir=docsDir1 as NSString
    /*
-(uint64_t)getFreeDiskspace {
uint64_t totalSpace = 0;
uint64_t totalFreeSpace = 0;
NSError *error = nil;
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

if (dictionary) {
NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
} else {
NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
}

return totalFreeSpace;
}
*/
    func convert_file_to_byteArray(filename:String)->Array<UInt8>
    {
        var file=fm.contentsAtPath(filename)
        //print(file?.debugDescription)
        print(file?.length)
        var bytes=Array<UInt8>(count: file!.length, repeatedValue: 0)
        
        // bytes.append(buffer.data.bytes)
        file!.getBytes(&bytes, length: (file?.length)!)
        // print(bytes.debugDescription)
        var sssss=NSString(bytes: &bytes, length: file!.length, encoding: NSUTF8StringEncoding)
        print("file contents are \(sssss)")
        print(bytes.capacity)
        print(bytes.debugDescription)
        return bytes
    /*java.io.FileInputStream fis = null;
    byte[] stream = new byte[(int) f.length()];
    try {
    fis = new java.io.FileInputStream(f);
    } catch (java.io.FileNotFoundException ex) {
    return null;
    }
    try {
    fis.read(stream);
    fis.close();
    } catch (java.io.IOException ex) {
    return null;
    }
    return stream;
*/
    }
    /*
private static final int CHUNK_SIZE = 16000;
private static final int CHUNKS_PER_ACK = 16;
*/
    
}