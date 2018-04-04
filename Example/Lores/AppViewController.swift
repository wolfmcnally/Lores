//
//  AppViewController.swift
//  Lores
//
//  Created by wolfmcnally on 03/03/2018.
//  Copyright (c) 2018 wolfmcnally. All rights reserved.
//

import WolfCore
import Lores

class AppViewController: ViewController {

    private lazy var programView: ProgramView = .init() • { 🍒 in
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view => [
            programView
        ]

        programView.backgroundImage = UIImage(named: "scanlines")!
        programView.backgroundTintColor = UIColor.white.darkened(by: 0.9)
        
        programView.constrainFrameToFrame()
        programView.program = program
        programView.program.didDisplay = {
            self.programView.flush()
        }
    }

    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        programView.program.display()
    }
}
