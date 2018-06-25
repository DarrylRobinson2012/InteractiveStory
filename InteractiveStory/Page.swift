//
//  Page.swift
//  InteractiveStory
//
//  Created by Darryl Robinson  on 3/7/18.
//  Copyright © 2018 Darryl Robinson . All rights reserved.
//

import Foundation

enum AdevntureError: Error {
    case nameNotProvided
}

class Page {
    let story: Story
    
    typealias Choice = (title: String, page: Page)
    
    var firstChoice: Choice?
    var secondChoice: Choice?
    
    init(story: Story){
        self.story = story
    }
}



extension Page {
    func addChoiceWith(title: String, story: Story)-> Page{
        let page = Page(story: story)
        return addChoiceWith(title: title, page: page)
    }
    func addChoiceWith(title: String, page: Page) -> Page {
        
        switch (firstChoice, secondChoice) {
        case (.some, .some): return self
        case (.none, .none), (.none, .some): firstChoice = (title, page)
        case (.some, .none): secondChoice = (title, page)
        }
        
        return page
    }
}


struct Adventure {
    
    static func story(withName name: String) -> Page {
        //Creates the first page choices
        let returnTrip = Page(story: .returnTrip(name: name))
        let touchdown = returnTrip.addChoiceWith(title: "Stop and Investigate", story: .touchDown)
        let homeward = returnTrip.addChoiceWith(title: "Continue home to Earth", story: .homeWard)
        // if User chooses touchdown they will be givin these choices
        let rover = touchdown.addChoiceWith(title: "Explore the Rover", story: .rover(name: name))
        let crate = touchdown.addChoiceWith(title: "Open the Crate", story: .crate)
        // if user chooses homeward they will be givin these choices
        homeward.addChoiceWith(title: "Head back to Mars", page: touchdown)
        let home = homeward.addChoiceWith(title: "Continue Home to Earth", story: .home)
        // if user chooses rover
        let cave = rover.addChoiceWith(title: "Explore the Coordinates", story: .cave)
        rover.addChoiceWith(title: "Return to Earth", page: home)
        //if user choses cave
        cave.addChoiceWith(title: "Continue towards faint light", story: .droid(name: name))
        cave.addChoiceWith(title: "Refill the ship and explore the rover", page: rover)
        //if user chooses crate
        crate.addChoiceWith(title: "Explore the Rover", page: rover)
        crate.addChoiceWith(title: "Use the key", story: .monster)
        
        return returnTrip
        
    }
    
}
