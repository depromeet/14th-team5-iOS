//
//  BBRecorderCore.swift
//  Core
//
//  Created by 김도현 on 12/23/24.
//

import Foundation

import AVFoundation

public class BBRecorderCore {
    
    public init() { }
    
    /// FileManager Documents Paths URL 가져오는 Property 입니다.
    public static var getDocumentsPath: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = UUID().uuidString + ".caf"
        return paths[0].appendingPathComponent(fileName)
    }()
    
    /// `AVAudioRecorder` 생성자 Property 입니다.
    public lazy var audioRecorder: AVAudioRecorder = {
        return try! AVAudioRecorder(url: Self.getDocumentsPath, settings: BBRecorderOption.default().asFormat())
    }()
    
    /// `AVAudioPlayer` 생성자 Property 입니다.
    public lazy var audioPlayer: AVAudioPlayer = {
        //TODO: Server 에서 제공된 URL을 사용해야함
        return try! AVAudioPlayer(contentsOf: Self.getDocumentsPath)
    }()

    /// 오디오 레코더가 녹음 중인지 여부를 나타내는 Boolean입니다.
    public var isRecording: Bool {
        return audioRecorder.isRecording
    }
    
}
