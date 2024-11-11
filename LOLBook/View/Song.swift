import SwiftUI
import AVKit

// 定義每首歌曲的資料模型
struct Song: Identifiable {
    let id = UUID()  // 每首歌曲的唯一識別碼
    let title: String  // 歌曲標題
    let artist: String  // 歌手名稱
    let image: String  // 歌曲封面圖片名稱
    let mp3FileName: String  // MP3音樂檔案名稱
    let youtubeURL: String  // YouTube影片URL
}

struct MusicView: View {
    // 定義一個歌曲數組，包含每首歌曲的相關資訊
    let songs: [Song] = [
        Song(title: "Warriors", artist: "Imagine Dragons", image: "warriors", mp3FileName: "Warriors", youtubeURL: "https://www.youtube.com/watch?v=fmI_Ndrxy14"),
        Song(title: "Worlds Collide", artist: "Nicki Taylor", image: "worldsCollide", mp3FileName: "Worlds", youtubeURL: "https://www.youtube.com/watch?v=4TwiTqa-Nr0"),
        Song(title: "Ignite", artist: "Zedd", image: "ignite", mp3FileName: "Ignite", youtubeURL: "https://www.youtube.com/watch?v=m6RVlXf8GCs"),
        Song(title: "Legends Never Die", artist: "Against the Current", image: "legendsNeverDie", mp3FileName: "Die", youtubeURL: "https://www.youtube.com/watch?v=r6zIGXun57U"),
        Song(title: "Rise", artist: "The Glitch Mob, Mako, The Word Alive", image: "rise", mp3FileName: "Rise", youtubeURL: "https://www.youtube.com/watch?v=fB8TyLTD7EE"),
        Song(title: "Giants", artist: "Becky G", image: "giants", mp3FileName: "True", youtubeURL: "https://www.youtube.com/watch?v=sVZpHFXcFJw"),
        Song(title: "Take Over", artist: "Jeremy McKinnon", image: "takeOver", mp3FileName: "Take", youtubeURL: "https://www.youtube.com/watch?v=2jAY-rp-6Y4"),
        Song(title: "Burn It All Down", artist: "PVRIS", image: "burnItAllDown", mp3FileName: "Burn", youtubeURL: "https://www.youtube.com/watch?v=aR-KAldshAE"),
        Song(title: "STAR WALKIN'", artist: "Lil Nas X", image: "starWalkin", mp3FileName: "Star", youtubeURL: "https://www.youtube.com/watch?v=rBLiDp7VYZM"),
        Song(title: "GODS", artist: "NewJeans", image: "gods", mp3FileName: "Gods", youtubeURL: "https://www.youtube.com/watch?v=GHgEc6kcU1M"),
        Song(title: "Heavy is the Crown", artist: "Linkin Park", image: "heavyIsTheCrown", mp3FileName: "Crown", youtubeURL: "https://www.youtube.com/watch?v=xTFIBchII_g")
    ]
    
    @State private var player: AVPlayer?  // 用來播放音樂的AVPlayer
    @State private var showVideoPlayer = false  // 用來控制顯示影片播放器的狀態
    @State private var selectedSong: Song?  // 儲存當前選擇的歌曲
    
    var body: some View {
        ScrollView {
            // 使用 LazyVGrid 實現可自適應的佈局
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                // 遍歷歌曲數組，為每首歌曲創建一個視圖
                ForEach(songs) { song in
                    SongView(song: song, playMusic: playMusic, openYouTube: openYouTube, showVideoPlayer: $showVideoPlayer, selectedSong: $selectedSong)
                }
            }
        }
        .sheet(isPresented: $showVideoPlayer) {
            if let selectedSong = selectedSong {
                // 顯示視頻播放器
                VideoPlayerView(song: selectedSong)
            }
        }
    }

    // 播放音樂的方法
    private func playMusic(from mp3FileName: String) {
        guard let url = Bundle.main.url(forResource: mp3FileName, withExtension: "mp3") else {
            print("File not found: \(mp3FileName).mp3")
            return
        }
        player = AVPlayer(url: url)
        player?.play()
    }

    // 打開YouTube影片的方法
    private func openYouTube(urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            print("Invalid YouTube URL")
            return
        }
        UIApplication.shared.open(url)
    }
}

struct SongView: View {
    let song: Song
    let playMusic: (String) -> Void
    let openYouTube: (String) -> Void
    @Binding var showVideoPlayer: Bool
    @Binding var selectedSong: Song?
    
    var body: some View {
        VStack {
            Image(song.image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 80)
                .cornerRadius(10)
            
            Text(song.title)
                .font(.headline)
                .onTapGesture {
                    selectedSong = song
                    showVideoPlayer = true
                }
            
            Text(song.artist)
                .font(.subheadline)
            
            HStack {
                Button(action: {
                    playMusic(song.mp3FileName)
                }) {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    openYouTube(song.youtubeURL)
                }) {
                    Image(systemName: "video.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}

struct VideoPlayerView: View {
    let song: Song
    
    var body: some View {
        VStack {
            Text("正在播放 \(song.title) - \(song.artist)")
                .font(.headline)
                .padding()

            VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: song.mp3FileName, withExtension: "mp3")!))
                .frame(height: 300)
                .cornerRadius(10)
        }
        .padding()
    }
}
