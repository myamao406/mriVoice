//
//  convertAudio.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/04/02.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation
import AVFoundation

func convertAudio(_ url: URL, outputURL: URL) {
    var error : OSStatus = noErr
    var destinationFile: ExtAudioFileRef? = nil
    var sourceFile : ExtAudioFileRef? = nil
    
    var srcFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
    var dstFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
    
    ExtAudioFileOpenURL(url as CFURL, &sourceFile)
    var thePropertySize: UInt32 = UInt32(MemoryLayout.stride(ofValue: srcFormat))
    
    ExtAudioFileGetProperty(sourceFile!,
                            kExtAudioFileProperty_FileDataFormat,
                            &thePropertySize, &srcFormat)
    
    let idx = asbds.index(where: {$0.projectNo == SELECT_PROJECT_NO})
    
    var tempAsbd:asbd?
    let mBytesPerFrame:UInt32?
    let mBytesPerPacket:UInt32?
    if idx == nil {
        tempAsbd = asbd(projectNo:SELECT_PROJECT_NO)
        
    } else {
        tempAsbd = asbds[idx!]
    }
    mBytesPerFrame = tempAsbd!.bitsPerChannel / 8 * tempAsbd!.channelsPerFrame
    mBytesPerPacket = mBytesPerFrame! * tempAsbd!.channelsPerFrame
    
    dstFormat.mSampleRate = tempAsbd!.sampleRate  //Set sample rate
    dstFormat.mFormatID = kAudioFormatLinearPCM
    dstFormat.mChannelsPerFrame = tempAsbd!.channelsPerFrame
    dstFormat.mBitsPerChannel = tempAsbd!.bitsPerChannel
    dstFormat.mBytesPerPacket = mBytesPerPacket!
    dstFormat.mBytesPerFrame = mBytesPerFrame!
    dstFormat.mFramesPerPacket = tempAsbd!.framesPerPacket
    dstFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked |
    kAudioFormatFlagIsSignedInteger

    
//    dstFormat.mSampleRate = sampleRate  //Set sample rate
//    dstFormat.mFormatID = kAudioFormatLinearPCM
//    dstFormat.mChannelsPerFrame = channelsPerFrame
//    dstFormat.mBitsPerChannel = bitsPerChannel
//    dstFormat.mBytesPerPacket = bytesPerPacket
//    dstFormat.mBytesPerFrame = bytesPerFrame
//    dstFormat.mFramesPerPacket = framesPerPacket
//    dstFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked |
//    kAudioFormatFlagIsSignedInteger
    
    // Create destination file
    error = ExtAudioFileCreateWithURL(
        outputURL as CFURL,
        kAudioFileWAVEType,
        &dstFormat,
        nil,
        AudioFileFlags.eraseFile.rawValue,
        &destinationFile)
    if error != 0 {
        print("Error 1 in convertAudio: \(error.description)")
    }
    error = ExtAudioFileSetProperty(sourceFile!,
                                    kExtAudioFileProperty_ClientDataFormat,
                                    thePropertySize,
                                    &dstFormat)
    if error != 0 {
        print("Error 2 in convertAudio: \(error.description)")
    }
    error = ExtAudioFileSetProperty(destinationFile!,
                                    kExtAudioFileProperty_ClientDataFormat,
                                    thePropertySize,
                                    &dstFormat)
    if error != 0 {
        print("Error 3 in convertAudio: \(error.description)")
    }
    
    let bufferByteSize : UInt32 = 32768
    var srcBuffer = [UInt8](repeating: 0, count: 32768)
    var sourceFrameOffset : ULONG = 0
    
    while(true){
        var fillBufList = AudioBufferList(
            mNumberBuffers: 1,
            mBuffers: AudioBuffer(
                mNumberChannels: 2,
                mDataByteSize: UInt32(srcBuffer.count),
                mData: &srcBuffer
            )
        )
        var numFrames : UInt32 = 0
        
        if(dstFormat.mBytesPerFrame > 0){
            numFrames = bufferByteSize / dstFormat.mBytesPerFrame
        }
        
        error = ExtAudioFileRead(sourceFile!, &numFrames, &fillBufList)
        if error != 0 {
            print("Error 4 in convertAudio: \(error.description)")
        }
        
        if(numFrames == 0){
            error = noErr;
            break;
        }
        
        sourceFrameOffset += numFrames
        error = ExtAudioFileWrite(destinationFile!, numFrames, &fillBufList)
        if error != 0 {
            print("Error 5 in convertAudio: \(error.description)")
        }
    }
    error = ExtAudioFileDispose(destinationFile!)
    if error != 0 {
        print("Error 6 in convertAudio: \(error.description)")
    }
    error = ExtAudioFileDispose(sourceFile!)
    if error != 0 {
        print("Error 7 in convertAudio: \(error.description)")
    }
}

