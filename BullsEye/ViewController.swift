//
//  ViewController.swift
//  BullsEye
//
//  Created by Noah Patterson on 2/25/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import UIKit
import GameplayKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var guess = 0 {
        didSet {
            guessLabel.text = "Put the bull's eye as close as you can to: \(guess)"
        }
    }
    
    var round = 1 {
        didSet {
            roundLabel.text = "Round: \(round)"
        }
    }
    
    @IBAction func hitButton(_ sender: Any) {
        let currentSliderNumber = lroundf(slider.value)
        let difference = abs(currentSliderNumber - guess)
        switch difference {
        case 0:
            score += 500
        case let x where x <= 10:
            score += 100
        case 11...50:
            score += 50
        case 50...100:
            score += 1
        default:
            return
        }
        let alert = UIAlertController(title: "You guessed: \(currentSliderNumber)", message: "You were \(difference) away and your new score is \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {
            [unowned self] _ in
            self.round += 1
            self.createGuessNumber()
        })
        present(alert, animated: true)
    }
    
    @IBAction func replayButton(_ sender: Any) {
        round = 1
        score = 0
        createGuessNumber()
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.add(transition, forKey: nil)
    }
    
//    @IBAction func infoButton(_ sender: Any) {
//        let alert = UIAlertController(title: "How to play", message: "Move the slider to get as close as you can to the suggested number.", preferredStyle: .alert)
//        present(alert, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        slider.setThumbImage(UIImage(named: "SliderThumb-Normal"), for: .normal)
        slider.setThumbImage(UIImage(named: "SliderThumb-Highlighted"), for: .highlighted)
        let insets = UIEdgeInsetsMake(0, 14, 0, 14)
        slider.setMinimumTrackImage(UIImage(named: "SliderTrackLeft")?.resizableImage(withCapInsets: insets), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "SliderTrackRight")?.resizableImage(withCapInsets: insets), for: .normal)
        createGuessNumber()
        score = 0
        round = 1
    }
    
    func createGuessNumber() {
        guess = GKRandomSource.sharedRandom().nextInt(upperBound: 100)
    }
}

