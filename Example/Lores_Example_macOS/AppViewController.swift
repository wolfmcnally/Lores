//
//  AppViewController.swift
//  Lores_Example_macOS
//
//  Created by Wolf McNally on 4/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Cocoa
import Lores
import WolfCore

class AppViewController: NSViewController {
    private lazy var programView = ProgramView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view => [
            programView
        ]

        programView.backgroundImage = OSImage(named: NSImage.Name(rawValue: "scanlines"))!
        programView.backgroundTintColor = OSColor(Color.white.darkened(by: 0.9))

        programView.constrainCenterToCenter()
        programView.constrainSizeToSize()
//        programView.constrainSize(to: CGSize(width: 200, height: 200))
//        Constraints(
//            programView.widthAnchor == view.widthAnchor =&= .defaultLow,
//            programView.heightAnchor == view.heightAnchor =&= .defaultLow,
//            programView.widthAnchor <= view.widthAnchor,
//            programView.heightAnchor <= view.heightAnchor
//            //programView.widthAnchor == clockView.heightAnchor
//        )

//        programView.constrainFrameToFrame()
        programView.program = program
        programView.program.didDisplay = {
            self.programView.flush()
        }

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        programView.program.display()
    }
}
