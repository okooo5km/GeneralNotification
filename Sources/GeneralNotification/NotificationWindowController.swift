//
//  NotificationWindowController.swift
//  GeneralNotification
//
//  Created by 十里 on 2024/10/04.
//

import Cocoa

private let notchHeight: CGFloat = 200

class NotificationWindowController: NSWindowController {
    init(screen: NSScreen) {
        let window = NotificationWindow(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        super.init(window: window)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError() }
}
