//
//  Song.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//


import SwiftUI
import AVKit

// 定義每首歌曲的資料模型
struct Song: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let image: String
    let mp3FileName: String
}

struct MusicView: View {
    // 定義一個歌曲數組，這裡使用檔案名稱
    let songs: [Song] = [
        Song(title: "Warriors", artist: "Imagine Dragons", image: "warriors", mp3FileName: "Warriors"),
        Song(title: "Worlds Collide", artist: "Nicki Taylor", image: "worldsCollide", mp3FileName: "Worlds"),
        Song(title: "Ignite", artist: "Zedd", image: "ignite", mp3FileName: "Ignite"),
        Song(title: "Legends Never Die", artist: "Against the Current", image: "legendsNeverDie", mp3FileName: "Die"),
        Song(title: "Rise", artist: "The Glitch Mob, Mako, The Word Alive", image: "rise", mp3FileName: "Rise"),
        Song(title: "Giants", artist: "Becky G", image: "giants",  mp3FileName: "True"),
        Song(title: "Take Over", artist: "Jeremy McKinnon", image: "takeOver", mp3FileName: "Take"),
        Song(title: "Burn It All Down", artist: "PVRIS", image: "burnItAllDown", mp3FileName: "Burn"),
        Song(title: "STAR WALKIN'", artist: "Lil Nas X", image: "starWalkin", mp3FileName: "Star"),
        Song(title: "GODS", artist: "NewJeans", image: "gods", mp3FileName: "Gods"),
        Song(title: "Heavy is the Crown", artist: "Linkin Park", image: "heavyIsTheCrown", mp3FileName: "Crown")
    ]
    
    @State private var player: AVPlayer?
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(songs) { song in
                    HStack {
                        Image(song.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            Text(song.artist)
                                .font(.subheadline)
                        }
                        Spacer()
                        
                        Button(action: {
                            playMusic(from: song.mp3FileName)
                        }) {
                            Image(systemName: "play.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    Divider()
                }
            }
        }
    }
    
    private func playMusic(from mp3FileName: String) {
        guard let url = Bundle.main.url(forResource: mp3FileName, withExtension: "mp3") else {
            print("File not found: \(mp3FileName).mp3")
            return
        }
        player = AVPlayer(url: url)
        player?.play()
    }
}

