//
//  SuccessPaymentViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 05/02/24.
//

import UIKit
import Lottie

class SuccessPaymentViewController: UIViewController {
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var successlabel: UILabel!
    
    var timeRemaining = 5
    var countdownTimer: Timer?
    private var lottieAnimationView : LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupAnimationView()
        }
        self.startCountdownTimer()
    }
    
    @objc func updateCountdown() {
        self.timeRemaining -= 1
        self.successlabel.text = "Automatically redirecting to home page in \(self.timeRemaining) seconds"
        if self.timeRemaining == 0 {
            self.countdownTimer?.invalidate()
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    func startCountdownTimer() {
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
    }
    
    func setupAnimationView() {
        self.lottieAnimationView = .init(name:"success")
        self.lottieAnimationView.frame = self.animationView.bounds
        self.lottieAnimationView.contentMode = .scaleAspectFit
        self.lottieAnimationView.loopMode = .loop
        self.lottieAnimationView.animationSpeed = 1.0
        self.animationView.addSubview(lottieAnimationView)
        self.lottieAnimationView.play()
    }
    
    @IBAction func bacToHomeAction(_ sender: Any) {
        self.countdownTimer?.invalidate()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
}
