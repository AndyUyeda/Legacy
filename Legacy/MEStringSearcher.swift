//
//  MEStringSearcher.swift
//  Legacy
//
//  Created by Andy Uyeda on 1/5/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

import Foundation

class MEStringSearcher : NSObject {
    
    var string : NSString!
    var length : Int!
    var range : NSRange!
    
    init(fromString str: NSString) {
        super.init()
        string = str
        length = string.length
        range = NSMakeRange(0, length)
    }
    func validRange(ran : NSRange, len : Int) ->Bool{
        if (range.location == NSNotFound || range.location + range.length > len){
            return false
        }
        else{
            return true
        }
    }
    func getStringWithLeftBounds(lft :NSString, rght : NSString) ->NSString?{
        var newStr : NSString!
        var newRange : NSRange!
        
        var leftRange : NSRange!
        var rightRange : NSRange!
        var leftSum : Int!
        var rightSum : Int!
        
        if(!validRange(range, len: length)){
            return nil
        }
        leftRange = string.rangeOfString(lft, options: NSStringCompareOptions.CaseInsensitiveSearch, range: range)
        if(!validRange(leftRange,len:length)){
            return nil
        }
        leftSum = (leftRange.location + leftRange.length) as Int
        
        //println(leftSum < length)
        if(leftSum > length){
            return nil
        }
        rightRange = string.rangeOfString(rght, options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(leftSum,length - leftSum))
        
        if(!validRange(rightRange, len: length)){
            return nil
        }
        rightSum = rightRange.location + rightRange.length as Int
        
        if(rightRange.location - leftSum <= 0){
            return nil
        }
        
        newRange = NSMakeRange(leftSum, rightRange.location - leftSum)
        if(!validRange(newRange, len: length)){
            return nil
        }
        
        newStr = string.substringWithRange(newRange)
        if(rightSum != 0){
            rightSum = rightSum - 1
        }
        range = NSMakeRange(rightSum, length - rightSum)
        
        return newStr
    }
    
    func moveBack(dis : Int){
        if(range.location >= dis){
            range.location -= dis
            range.length += dis
        }
    }
    
    func moveForward(dis : Int){
        if(range.location <= dis){
            range.location += dis
            range.length -= dis
        }
    }
    func moveToString(str : NSString){
        var tempR : NSRange!
        tempR = string.rangeOfString(str, options: NSStringCompareOptions.CaseInsensitiveSearch, range: range)
        if(validRange(tempR, len: length)){
            range.location = tempR.location + tempR.length
            range.length = length - range.location
        }
        
    }
    func moveToBeginning(){
        range = NSMakeRange(0, length)
    }
    


}
