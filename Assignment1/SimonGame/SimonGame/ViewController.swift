//
//  ViewController.swift
//  SimonGame
//
//  Created by Yuvaraj Mayank Konjeti on 1/11/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var highScoreValueLabel: UILabel!
    @IBOutlet weak var gameLevelLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var redSoundButton: UIButton!
    @IBOutlet weak var yellowSoundButton: UIButton!
    @IBOutlet weak var greenSoundButton: UIButton!
    @IBOutlet weak var blueSoundButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var gameSounds = [String:URL]()
    
    var redSound: AVAudioPlayer!
    var yellowSound: AVAudioPlayer!
    var greenSound: AVAudioPlayer!
    var blueSound: AVAudioPlayer!
    
    var computerGeneratedNumbers: [Int] = [Int]()
    var userSelectedNumbers: [Int] = [Int]()
    
    var totalScore = 0
    var level = 1
    var playerAndScores: [String: Int] = [:]
    var currentPlayer = Players.player1
    
    var mainCurrentPlayer = Players.player1

    // MARK: set how many players here manually.
    let numberOfPlayersToPlay: [Players] = [.player1, .player2]
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSounds()
        self.updateHighScore()
        
        for i in numberOfPlayersToPlay {
            playerAndScores["\(i.rawValue)"] = 0
        }
        
        if currentPlayer == numberOfPlayersToPlay[0] {
            
        }
    }
    
    private func saveScore() {
        let sorted = playerAndScores.sorted { $0.1 > $1.1 }
        print("sorted: \(sorted)")
        let high = userDefaults.integer(forKey: "high-score")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        let string = formatter.string(from: date)
        
        if sorted[0].value > high {
            userDefaults.set(sorted[0].value, forKey: "high-score")
            userDefaults.set(string, forKey: "high-score-date")
        }
    }
    
    // generate random color
    private func getRandomColor() -> UIButton {
        return [redSoundButton, yellowSoundButton, greenSoundButton, blueSoundButton].randomElement()!
    }
    
    @IBAction func playAct(_ sender: AnyObject) {
        startAutoPlay()
        updateButton(.pause)

        let sorted = playerAndScores.sorted { $0.1 > $1.1 }
        scoreLabel.text = "\(currentPlayerx()) SCORE: \(sorted[0].value)"

        saveScore()

        nextPlayer()
        
        
    }
    
    @IBAction func playSoundButtonAct(_ sender: AnyObject) {
        self.newGame()
        
        let button = sender as! UIButton
        self.onTapSound(button)
        userSelectedNumbers.append(button.tag)
        let pickNumbers = computerGeneratedNumbers.sorted()
        let selectedNumbers = userSelectedNumbers.sorted()
        
        if pickNumbers.count == selectedNumbers.count {
            if pickNumbers == selectedNumbers { // correct answer
                
                self.continueGame()
            } else { // on wrong answer
                self.presentGameover()
            }
            updateData()
        }
    }
    
    private func updateHighScore() {
        let highScore = userDefaults.integer(forKey: "high-score")
        let highScoreDate = userDefaults.string(forKey: "high-score-date") ?? ""
        
        highScoreValueLabel.text = "\(highScore) - (\(highScoreDate))"
    }
    
    // play sound
    private func onTapSound(_ button: UIButton) {
        button.alpha = 0.5
        
        switch button.tag {
        case 1:
            redSound.play()
        case 2:
            yellowSound.play()
        case 3:
            greenSound.play()
        case 4:
            blueSound.play()
        default: break
        }
        
        // making alpha value to 1.0 after pressing button
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            button.alpha = 1.0
        }
        
        // on finishing
        if level == computerGeneratedNumbers.count + 1 {
            updateButton(.play)
        }
    }
    
    // computer generated taps
    private func startAutoPlay() {
        for i in 1...level {
            let randomColor = self.getRandomColor()
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.onTapSound(randomColor)
                self.computerGeneratedNumbers.append(randomColor.tag)
            }
        }
    }

    private func continueGame() {
        instructionLabel.text = "CORRECT! tap on play to continue"
        gameLevelLabel.text = "\(level)"
        
        playerAndScores["\(mainCurrentPlayer.rawValue)"]! += 1
        level += 1

        self.updateData()
    }

    private func nextPlayer() {
        mainCurrentPlayer = currentPlayerx()
        let x = currentPlayerx()
        scoreLabel.text = "\(x.rawValue) Score: \(playerAndScores["\(x.rawValue)"] ?? 0)"
        
        switch x {
        case .player1:
            currentPlayer = .player2
        case .player2:
            currentPlayer = .player3
        case .player3:
            currentPlayer = .player4
        case .player4:
            currentPlayer = .player5
        case .player5:
            currentPlayer = .player1
        }
        
        instructionLabel.text = "\(x.rawValue) turn"
    }

    private func currentPlayerx() -> Players {
        if numberOfPlayersToPlay.contains(.player1) && currentPlayer == .player1 {
            return .player1
        } else if numberOfPlayersToPlay.contains(.player2) && currentPlayer == .player2 {
            return .player2
        } else if numberOfPlayersToPlay.contains(.player3) && currentPlayer == .player3 {
            return .player3
        } else  if numberOfPlayersToPlay.contains(.player4) && currentPlayer == .player4 {
            return .player4
        } else  if numberOfPlayersToPlay.contains(.player5) && currentPlayer == .player5 {
            return .player5
        }
        
        return .player1
    }

    private func presentGameover() {
        instructionLabel.text = "GAME OVER! tap on play for a new game"
        print("GAME OVER! final scores: \(playerAndScores)")
        let sorted = playerAndScores.sorted { $0.1 > $1.1 }

        presentAlert(title: "\(sorted[0].key) Wins!!!", message: "Score: \(sorted[0].value)")
        
       // totalScore = 0
        for i in playerAndScores {
            playerAndScores.updateValue(0, forKey: i.key)
        }
        
        level = 1

        let highScore = userDefaults.integer(forKey: "high-score")
        let highScoreDate = userDefaults.string(forKey: "high-score-date") ?? ""

        highScoreValueLabel.text = "\(highScore) - (\(highScoreDate))"
    }

    private func newGame() {
        instructionLabel.text = "-"
    }

    // update required data
    private func updateData() {
        self.computerGeneratedNumbers = []
        self.userSelectedNumbers = []
        gameLevelLabel.text = "\(level)"
    }
    
    // getting sound and play sound
    private func setupSounds() {
        let redSoundPath = Bundle.main.path(forResource: "red", ofType: "mp3")!
        let yellowSoundPath = Bundle.main.path(forResource: "yellow", ofType: "mp3")!
        let greenSoundPath = Bundle.main.path(forResource: "green", ofType: "mp3")!
        let blueSoundPath = Bundle.main.path(forResource: "blue", ofType: "mp3")!
        
        let redSoundURL = URL(fileURLWithPath: redSoundPath)
        let yellowSoundURL = URL(fileURLWithPath: yellowSoundPath)
        let greenSoundURL = URL(fileURLWithPath: greenSoundPath)
        let blueSoundURL = URL(fileURLWithPath: blueSoundPath)
        
        do {
            try redSound = AVAudioPlayer(contentsOf: redSoundURL)
            try yellowSound = AVAudioPlayer(contentsOf: yellowSoundURL)
            try greenSound = AVAudioPlayer(contentsOf: greenSoundURL)
            try blueSound = AVAudioPlayer(contentsOf: blueSoundURL)
        }
        catch {
            print("ERROR: \(error.localizedDescription)")
        }
        
        [redSound, yellowSound, greenSound, blueSound]
            .forEach {
                $0?.delegate = self
                $0?.numberOfLoops = 0
            }
    }
    
    // updates game button state
    private func updateButton(_ state: ButtonState) {
        switch state {
        case .pause:
            let image = UIImage(systemName: "pause.fill")
            startGameButton.setImage(image, for: .normal)
        case .play:
            let image = UIImage(systemName: "play.fill")
            startGameButton.setImage(image, for: .normal)
        }
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ok", style: .default) { action in
            //
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}


enum ButtonState {
    case play
    case pause
}

enum Players: String, CaseIterable {
    case player1 = "Player 1"
    case player2 = "Player 2"
    case player3 = "Player 3"
    case player4 = "Player 4"
    case player5 = "Player 5"
}

// each player has: name, score
