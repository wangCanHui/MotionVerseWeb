//
//  Recorder.swift
//  MotionverseDemo
//
//  Created by zksz1 on 2022/12/20.
//

import Foundation
import AVFoundation

final class Recorder: NSObject {
    
    static let shared = Recorder()
    private var audioSession: AVAudioSession? = nil
    
    private let audioPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "") + "/audio.wav"
    private var recorder: AVAudioRecorder!
    // MARK: - Init
    override init() {
        super.init()
        
    }
    // MARK: -
    private func clearFile() {
        do {
            if FileManager.default.fileExists(atPath: audioPath) {
                try FileManager.default.removeItem(atPath: audioPath)
            }
        } catch {
            print(error)
        }
    }
    func config() {
        clearFile()
        let url = URL(fileURLWithPath: audioPath)
        let recorder = try! AVAudioRecorder(url: url, settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVSampleRateKey: 16000, AVNumberOfChannelsKey: 1, AVLinearPCMBitDepthKey: 16, AVLinearPCMIsFloatKey: false])
        recorder.delegate = self
        recorder.prepareToRecord()
        self.recorder = recorder
    }
    func play() {
        config()
        self.audioSession = AVAudioSession.sharedInstance()
        try! self.audioSession?.setCategory(.playAndRecord)
        try! self.audioSession?.setActive(true)
        self.recorder.record()
    }
    func stop() {
        self.recorder.stop()
    }
    var result: String {
        let data = try! Data(contentsOf: URL(fileURLWithPath: audioPath))
        return data.base64EncodedString()
    }
}
extension Recorder: AVAudioRecorderDelegate {
    
}
