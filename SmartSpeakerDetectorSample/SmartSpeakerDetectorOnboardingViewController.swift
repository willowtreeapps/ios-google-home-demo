//
//  SmartSpeakerDetectorOnboardingViewController.swift
//  SmartSpeakerDetectorSample
//
//  Created by Luke Tomlinson on 4/11/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

import UIKit

class SmartSpeakerDetectorOnboardingViewController: UIViewController {

    @IBOutlet var messageViewHeight: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var zeroOneConstraint: NSLayoutConstraint!
    @IBOutlet var oneTwoConstraint: NSLayoutConstraint!
    @IBOutlet var twoThreeConstraint: NSLayoutConstraint!
    @IBOutlet var fiveSixConstraint: NSLayoutConstraint!
    @IBOutlet var threeFourConstraint: NSLayoutConstraint!
    @IBOutlet var bottomPictureConstraint: NSLayoutConstraint!
    @IBOutlet var fourFiveConstraint: NSLayoutConstraint!
    @IBOutlet var zeroToPicture: NSLayoutConstraint!

    @IBOutlet var messageBubbleImageView: UIImageView!
    @IBOutlet var messageBubbleTextImageView: UIImageView!
    @IBOutlet var view0: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var messageViews: [UIView]!
    @IBOutlet var finalMessageTextImageView: UIImageView!
    @IBOutlet var finalMessageImageView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var googleHomeImage: UIImageView!
    @IBOutlet var ctaButton: UIButton!
    @IBOutlet var viewToHideSliding: UIView!

    let spacings: [CGFloat] = [28, 40, 24, 24, 24, 24]
    let cumulativeSpacings: [CGFloat] = [28.0 + 48.0, 40+28, 28+24, 28+24+24, 28+24, 24+24]
    let animatingMessage: [UIImage] = [#imageLiteral(resourceName: "msg1"),#imageLiteral(resourceName: "msg2"),#imageLiteral(resourceName: "msg3")]

    var spacingConstraints: [NSLayoutConstraint] {
        return [zeroOneConstraint,
                oneTwoConstraint,
                twoThreeConstraint,
                threeFourConstraint,
                fourFiveConstraint,
                fiveSixConstraint]
    }

    var fadeInViews: [UIView] {
        return [messageBubbleTextImageView,
                finalMessageTextImageView,
                ctaButton,
                closeButton,
                googleHomeImage]
    }

    static func fromStoryboard() -> SmartSpeakerDetectorOnboardingViewController {
        let storyboard = UIStoryboard(name: "SmartSpeakerDetectorOnboarding", bundle: nil)
        return storyboard.instantiateInitialViewController() as! SmartSpeakerDetectorOnboardingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //prepare constraints
        bottomPictureConstraint.constant = -50
        zeroToPicture.constant = -500
        spacingConstraints.forEach { $0.constant = 1000}

        //prepare alphas
        viewToHideSliding.alpha = 1.0
        fadeInViews.forEach { $0.alpha = 0.0 }

        //prepare imageViews
        messageBubbleTextImageView.image = #imageLiteral(resourceName: "hallo")
        finalMessageTextImageView.image = #imageLiteral(resourceName: "tryMeOut")

        [messageBubbleImageView, finalMessageImageView].forEach { imageView in
            imageView?.animationImages = animatingMessage
            imageView?.animationDuration = 1.25
            imageView?.startAnimating()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialAnimation { _ in
            self.animateChat { _ in
                self.finalAnimation()
            }
        }

    }

    func finalAnimation() {
        let initialAnimations = {
            self.fiveSixConstraint.constant = -154
            self.messageViews.forEach ({ $0.alpha = 0.0 })
            self.view.layoutIfNeeded()
        }
        let messageAnimations = {
            self.finalMessageImageView.alpha = 0.0
            self.finalMessageTextImageView.alpha = 1.0
        }
        let buttonAnimations = {
            self.ctaButton.alpha = 1.0
            self.closeButton.alpha = 1.0
        }

        UIView.animate(withDuration: 1.25,
                       delay: 1.25,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: initialAnimations) { _ in
                        
                        UIView.animate(withDuration: 0.5,
                                       delay: 0.0,
                                       options: [],
                                       animations: messageAnimations) { _ in
                                        
                                        UIView.animate(withDuration: 0.5,
                                                       delay: 1.0,
                                                       options: [],
                                                       animations: buttonAnimations,
                                                       completion: nil)
                        }
        }
    }

    func initialAnimation(completion: @escaping (Bool) -> Void) {
        let animations = {
            self.bottomPictureConstraint.constant = 0.0
            self.zeroToPicture.constant = 77
            self.googleHomeImage.alpha = 1.0
            self.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: animations,
                       completion: completion)
    }

    func animateChat(completion: @escaping (Bool) -> Void) {
        var delay: TimeInterval = 1.0

        let items = zip(zip(0...10, self.spacingConstraints.dropLast()), zip(spacings, cumulativeSpacings)).map { item in
            return (item.0.0, item.0.1, item.1.0, item.1.1)
        }

        for (index, constraint, constant, cumulative) in items {

            let fadeOutViews: [UIView]

            if index >= 2 {
                fadeOutViews = Array(messageViews.prefix(through: index - 2))
            } else {
                fadeOutViews = []
            }

            let animations = {
                print("starting animation index: \(index)")
                if index == self.spacingConstraints.count - 3 {
                    self.zeroOneConstraint.constant -= 80
                    self.view1.alpha = 0.0
                    self.messageViewHeight.constant = 0.0
                    constraint.constant = constant
                    self.zeroToPicture.constant += cumulative
                    self.view.layoutIfNeeded()

                } else {
                    constraint.constant = constant
                    self.zeroToPicture.constant += cumulative
                    self.view.layoutIfNeeded()
                }
            }

            let complete: ((Bool) -> Void)?
            switch index {
            case (spacingConstraints.count - 2):
                complete = completion
            case 0:
                complete = { _ in
                    UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                        self.messageBubbleTextImageView.alpha = 1.0
                        self.messageBubbleImageView.alpha = 0.0
                    }, completion: nil)
                }
            default:
                complete = { _ in
                    fadeOutViews.forEach { fadeView in
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                            fadeView.alpha -= 0.2
                        }, completion: nil)
                    }
                }
            }

            UIView.animate(withDuration: 1.0,
                           delay: delay,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: animations,
                           completion: complete)

            if index == 0 {
                delay += 3.0
            } else {
                delay += 1.5
            }
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
