//
//  NotificationViewController.swift
//  GeneralNotification
//
//  Created by 十里 on 2024/10/04.
//

import AppKit
import Cocoa
import SwiftUI

class ClickableHostingView<Content: View>: NSHostingView<Content> {
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }
}

class NotificationViewController: NSHostingController<AnyView> {
    init(_ view: AnyView) {
        super.init(rootView: view)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    convenience init(_ view: some View) {
        self.init(AnyView(view))
    }

    override func loadView() {
        view = ClickableHostingView(rootView: rootView)
    }
}
