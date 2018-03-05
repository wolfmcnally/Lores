//
//  BackgroundView.swift
//  Lores
//
//  Created by 🐺 McNally on 3/3/18.
//

import WolfCore

class BackgroundView : ImageView {
    override func setup() {
        super.setup()

        contentMode = .scaleAspectFill
        backgroundColor = UIColor.black
    }
}
