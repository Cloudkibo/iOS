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
    let fm = FileManager.default
    
    
    //credit:http://stackoverflow.com/questions/5712527/how-to-detect-total-available-free-disk-space-on-the-iphone-ipad-device
   
    
    
    class func exists (_ path: String) -> Bool {
        return FileManager().fileExists(atPath: path)
    }
    
    class func read (_ path: String, encoding: String.Encoding = String.Encoding.utf8) -> Data? {
        if FileUtility.exists(path) {
            return (try? Data(contentsOf: URL(fileURLWithPath: path)))
        }
        
        return nil
    }
    
    class func write (_ path: String, content: Data, encoding: String.Encoding = String.Encoding.utf8) -> Bool {
        return ((try? content.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil)
    }


////let read : NSData? = FileUtility.read("/path/to/file.txt")

//print(read)

///let write : Bool = FileUtility.write("/path/to/file2.txt", content: NSData(contentsOfFile: "This is a test String")!)

//print(write)


    func getfreeDiskSpace()->UInt64
    {
       // var dictionary:[String:AnyObject]=["":"" as AnyObject]
        var dictionary=[FileAttributeKey : AnyObject]()
        var totalspace:UInt64=0
        var totalFreeSpace:UInt64=0
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        do
            {
                var dictionary = try FileManager.default.attributesOfFileSystem(forPath: paths.last!) as! [FileAttributeKey : AnyObject]
            }
        catch
            {   print("error")
                print(dictionary)
            }
        if(dictionary.count>0)
        {
            //for items in dictionary.keys
            //{
            var fileSystemSizeInBytes:NSNumber = dictionary[FileAttributeKey.systemSize] as! NSNumber
            var freeFileSystemSizeInBytes:NSNumber = dictionary[FileAttributeKey.systemFreeSize] as! NSNumber
            print("filesystem size is \(fileSystemSizeInBytes)")
            print("filesystemfree size is \(freeFileSystemSizeInBytes)")
            totalspace=fileSystemSizeInBytes.uint64Value
            totalFreeSpace=freeFileSystemSizeInBytes.uint64Value
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
    
    func isFreeSpacAvailable(_ fileSize:Int)->Bool
    {
        let fileSize = fileSize
        let totalfreespace=getfreeDiskSpace()
        let test=UInt64(10000000)
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
    func convert_file_to_byteArray(_ filename:String)->Array<UInt8>
    {
        var file=fm.contents(atPath: filename)
        
        //print(file?.debugDescription)
        if(file==nil)
        {
            
            
            file=try? Data(contentsOf: urlLocalFile as URL)
            if(file == nil)
            {
                 print("invalid file. Choose other file type please")
                
            }
          
            
        }
        if(file != nil)
        {
        print(file?.count)
        var bytes=Array<UInt8>(repeating: 0, count: file!.count)
        
        // bytes.append(buffer.data.bytes)
        (file! as NSData).getBytes(&bytes, length: (file?.count)!)
        // print(bytes.debugDescription)
        let sssss=NSString(bytes: &bytes, length: file!.count, encoding: String.Encoding.utf8.rawValue)
        print("file contents are \(sssss)")
        print(bytes.capacity)
        print(bytes.debugDescription)
        return bytes
        }
        else
        {let bytes=Array<UInt8>(repeating: 0, count: 0)
        return bytes}
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
  
    
    func convert_byteArray_to_fileNSData(_ filecontent:Array<UInt8>)->Data
    {
        var myfile=filecontent
        //var file=fm.contentsAtPath(filename)
        //print(file?.debugDescription)
       // print(filecontent.length)
        //var bytes=Array<UInt8>(count: file!.length, repeatedValue: 0)
        var file:Data!
        // bytes.append(buffer.data.bytes)
        //file!.getBytes(&filecontent, length: (file?.length)!)
               // print(bytes.debugDescription)
         file=Data(bytes: UnsafePointer<UInt8>(filecontent), count: filecontent.count)
       // var sssss=NSString(bytes: &bytes, length: file!.length, encoding: NSUTF8StringEncoding)
       
        return file
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

}
