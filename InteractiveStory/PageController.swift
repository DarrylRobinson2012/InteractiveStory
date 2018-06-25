//
//  PageController.swift
//  InteractiveStory
//
//  Created by Darryl Robinson  on 3/7/18.
//  Copyright © 2018 Darryl Robinson . All rights reserved.
//

import UIKit
extension NSAttributedString {
    var stringRange: NSRange {
        return NSMakeRange(0, self.length)
    }
}

extension Story {
    var attributesText: NSAttributedString{
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: attributedString.stringRange)
        return attributedString
    }
}

extension Page {
    func story(attributed: Bool) -> NSAttributedString {
        if attributed {
            return story.attributesText
        }else {
            return NSAttributedString(string: story.text)
        }
    }
    
}
class PageController: UIViewController {
    
    var page: Page?
    let soundEffectsPlayer = SoundEffectsPlayer()
    
    
    //Mark: - User Interface Properties
    lazy var artworkView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.page?.story.artwork
        
        return imageView
        
    }()
    
    lazy var  storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.attributedText = self.page?.story(attributed: true)
        
        return label
    }()
    
    lazy var firstChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = self.page?.firstChoice?.title ?? " Play Again "
        let selector = self.page?.firstChoice != nil ? #selector(PageController.loadFirstChoice) : #selector(PageController.playAgain)
        
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        return button
    }()
    
    lazy var secondChoiceButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.setTitle(self.page?.secondChoice?.title, for: .normal)
        button.addTarget(self, action: #selector(PageController.loadSecondChoice), for: .touchUpInside)
        
        
        return button
    }()
    
    
    
    // How TO work around the swift initializer maddness
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }

    init(page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        /* Took Out because anonymous function in artworkView
        super.viewWillLayoutSubviews()
        */
        //adding the artwork
        view.addSubview(artworkView)
        //setting automatic contraints off
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        
        //Contructing the layout of the storyLabel textview
        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(equalTo: view.topAnchor),
            artworkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            artworkView.rightAnchor.constraint(equalTo: view.rightAnchor),
            artworkView.leftAnchor.constraint(equalTo: view.leftAnchor),
            ])
        //adding the textview
        view.addSubview(storyLabel)
        /* Took out because of anonymous Function in storylabel
        storyLabel.numberOfLines = 0
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        */
        NSLayoutConstraint.activate([
            storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            storyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -48.0)
            ])
        //adding buttons
        view.addSubview(firstChoiceButton)
        //AF: firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80.0)
            ])
        
        view.addSubview(secondChoiceButton)
        // AF: secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            
            ])
    }
    //activating buttons
    @objc func loadFirstChoice() {
        if let page = page, let firstChoice = page.firstChoice {
            let nextPage = firstChoice.page
            let pageController = PageController(page: nextPage)
            soundEffectsPlayer.playSound(for: firstChoice.page.story)
            navigationController?.pushViewController(pageController, animated: true)
            
        }
    }
    //activating buttons
    @objc func loadSecondChoice() {
        if let page = page, let secondChoice = page.secondChoice {
            let nextPage = secondChoice.page
            let pagecontroller = PageController(page: nextPage)
            
            soundEffectsPlayer.playSound(for: secondChoice.page.story)
            navigationController?.pushViewController(pagecontroller, animated: true)
        }
    }
    @objc func playAgain(){
        navigationController?.popToRootViewController(animated: true)
    }
   
}
