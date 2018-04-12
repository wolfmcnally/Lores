//
//  ViewController.swift
//  Lores_Example_tvOS
//
//  Created by Wolf McNally on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import WolfCore
import Lores

import GameController

class LoresViewController: GCEventViewController {
    private lazy var programView = ProgramView()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _setup()
    }

    private func _setup() {
        setup()
    }

    open func setup() { }

    override func viewDidLoad() {
        super.viewDidLoad()

        view => [
            programView
        ]

        //programView.backgroundImage = OSImage(named: "scanlines")!
        programView.backgroundTintColor = OSColor.white.darkened(by: 0.9)

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

class AppViewController: LoresViewController {
}
