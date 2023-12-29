//
//  MusicPlayerManager.swift
//  BottomTray
//
//  Created by Carson Gross on 12/21/23.
//

import MusicKit
import Foundation

@Observable final class MusicPlayerManager {
    static let shared = MusicPlayerManager()
    
    private init() { }
    
    var album: Album?
    /// The MusicKit player to use for Apple Music playback.
    private var player = ApplicationMusicPlayer.shared {
        didSet {
            notifyObservers()
        }
    }
    
    /// The state of the MusicKit player to use for Apple Music playback.
    private var playerState = ApplicationMusicPlayer.shared.state
    
    /// `true` when the album detail view sets a playback queue on the player.
    public private(set) var isPlaybackQueueSet = false
        
    private var isPlaying: Bool {
        playerState.playbackStatus == .playing
    }
    
    private var observers = [PlayerObserver]()
    
    func handlePlayPause() {
        guard isPlaybackQueueSet else { return }
        if isPlaying {
            player.pause()
            notifyObservers()
        } else {
            Task {
                do {
                    try await player.play()
                    notifyObservers()
                } catch {
                    print("Failed to resume playing with error: \(error).")
                }
            }
        }
    }
    
    func handlePlayButtonSelected(album: Album) {
        if album != self.album {
            isPlaybackQueueSet = false
        }
        
        self.album = album
        
        if !isPlaying {
            if !isPlaybackQueueSet {
                player.queue = [album]
                isPlaybackQueueSet = true
                beginPlaying()
                notifyObservers()
            } else {
                Task {
                    do {
                        try await player.play()
                        notifyObservers()
                    } catch {
                        print("Failed to resume playing with error: \(error).")
                    }
                }
            }
        } else {
            player.pause()
            notifyObservers()
        }
    }
    
    /// The action to perform when the user taps a track in the list of tracks.
    func handleTrackSelected(_ track: Track, loadedTracks: MusicItemCollection<Track>) {
        player.queue = ApplicationMusicPlayer.Queue(for: loadedTracks, startingAt: track)
        isPlaybackQueueSet = true
        beginPlaying()
    }
    
    /// A convenience method for beginning music playback.
    ///
    /// Call this instead of `MusicPlayer`’s `play()`
    /// method whenever the playback queue is reset.
    private func beginPlaying() {
        Task {
            do {
                try await player.play()
                notifyObservers()
            } catch {
                print("Failed to prepare to play with error: \(error).")
            }
        }
    }
}

extension MusicPlayerManager: PlayerSubject {
    func registerObserver(_ observer: PlayerObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: PlayerObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.update(with: player)
        }
    }
}
