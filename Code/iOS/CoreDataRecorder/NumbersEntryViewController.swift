//
//  ViewController.swift
//  Test
//
//  Created by Me on 27/09/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import GameKit

class NumbersEntryViewController: UIViewController {
    
    var language = "string"
    var age = "23"
    var gender = "male"
    var rightHanded = true
    
    var numbersToSpeak = [Int]()
    
    var usedNumbers = [Int]()
    
    let synthesizer = AVSpeechSynthesizer()
    
    var utterance = AVSpeechUtterance(string: "Please draw the following numbers using your index finger")
    let context = DatabaseController.persistentContainer.viewContext
    
    //  declared to be an implicitly unwrapped optional
    //  because it doesn't make sense to give it a non-nil initial value.
    private var embeddedViewController: DrawViewController!
    
    var count = 1
    var complete = false
    
    @IBAction func redo(_ sender: UIButton) {
        self.embeddedViewController.points = [CGPoint]()
        self.embeddedViewController.updateUI()
        synthesizer.speak(utterance)
    }
    
    
    func randomNumbers(range: Range<Int>) -> Array<Int> {
        let min = range.lowerBound
        let max = range.upperBound
        
        var unshuffledNumbers = [Int]()
        
        for _ in 1...8{
            unshuffledNumbers.append(contentsOf: Array(min..<max))
        }
        
        let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: unshuffledNumbers)
        return shuffledNumbers as! Array<Int>
        
    }
    
    
    @IBAction func nextNumber(_ sender: ProgressButton) {
        sender.increment();
        let character = Character(context: DatabaseController.persistentContainer.viewContext)
        character.t = embeddedViewController.charTime.reduce(0, +)
        embeddedViewController.charTime = [CFAbsoluteTime]()
        DatabaseController.saveContext()
        
        if complete {
         self.embeddedViewController.points = [CGPoint]()
         self.embeddedViewController.updateUI()
         return
        }
        
        if(count == 80){
            complete = true
            DatabaseController.saveContext()
            self.performSegue(withIdentifier: "summarySegue", sender: self)
            utterance = AVSpeechUtterance(string: "Thank you")
            synthesizer.speak(utterance)
        }
        
        if(count == 40){
            sender.progress = 0
            self.performSegue(withIdentifier: "changeHandSegue", sender: self)
            utterance = AVSpeechUtterance(string: "Please switch to your thumb")
            synthesizer.speak(utterance)
        
        }
        
        if count < 80 , count != 40{
        self.embeddedViewController.points = [CGPoint]()
        self.embeddedViewController.updateUI()
        
        utterance = AVSpeechUtterance(string: "\(numbersToSpeak[count])")
        synthesizer.speak(utterance)
        
        count += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.embeddedViewController.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        synthesizer.speak(utterance)
        numbersToSpeak = randomNumbers(range: 0..<10)
        utterance = AVSpeechUtterance(string: "\(numbersToSpeak[0])")
        synthesizer.speak(utterance)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
            }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let dvc = segue.destination as? SummaryViewController {
            dvc.language = language
            dvc.age = age
            dvc.gender = gender
            dvc.rightHanded = rightHanded
        }
        
        if let evc = segue.destination as? DrawViewController{
            self.embeddedViewController = evc
        }
    }
    
    @IBAction func unwindfromChangeFingerView(segue: UIStoryboardSegue) {
        if let svc = segue.source as? ChangeToThumbViewController {
            //self.touchesCount = svc.points.count
            count = svc.count
            self.embeddedViewController.points = [CGPoint]()
            self.embeddedViewController.updateUI()
            utterance = AVSpeechUtterance(string: "Please draw the following numbers using your Thumb")
            synthesizer.speak(utterance)
            utterance = AVSpeechUtterance(string: "\(numbersToSpeak[40])")
            synthesizer.speak(utterance)
        }
    }
    
    //  Now in other methods you can reference `embeddedViewController`.
    //  For example:
//    override func viewDidAppear(animated: Bool) {
//        self.embeddedViewController.points
//    }
    
    

//    func prepare(for segue: "completionSegue", sender: AnyObject?) {
//        if segue.identifier == "completionSegue" {
//            if let viewController = segue.destination as? HappinessViewController {
//                //viewController.property = property
//            }
//        }
//    }
    

}

