//
//  PopUpViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 13/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showViewAnimated()
    }
    
    private func showViewAnimated() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: K.Design.AnimationTime, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    private func removeViewAnimated(callback: @escaping () -> Void) {
        UIView.animate(withDuration: K.Design.AnimationTime, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion:{(finished : Bool) in
            if (finished) {
                self.view.removeFromSuperview()
                callback()
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        
        //        if (!followContainer.frame.contains(location)) {
        //
        //        }
        removeViewAnimated {
            self.dismiss(animated: false, completion: nil)
        }
    }
    

}
