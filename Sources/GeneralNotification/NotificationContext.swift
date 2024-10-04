//
//  NotificationContext.swift
//  GeneralNotification
//
//  Created by 十里 on 2024/10/04.
//

import Cocoa
import Foundation
import SwiftUI

struct NotificationContext {
    let screen: NSScreen
    let bodyView: AnyView

    init(screen: NSScreen, bodyView: AnyView) {
        self.screen = screen
        self.bodyView = bodyView
    }

    init?(bodyView: AnyView) {
        let mouseLocation = NSEvent.mouseLocation
        let screens = NSScreen.screens
        let screenWithMouse =
            (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })

        guard let screen = screenWithMouse ?? NSScreen.buildin else {
            return nil
        }
        self.init(
            screen: screen,
            bodyView: bodyView
        )
    }

    init?(bodyView: some View) {
        self.init(bodyView: AnyView(bodyView))
    }

    func open(forInterval interval: TimeInterval = 0) {
        let window = NotificationWindowController(screen: screen)
        window.window?.setFrameOrigin(.zero)

        let viewModel = NotificationViewModel(
            screen: screen,
            bodyView: bodyView
        )
        let view = NotificationView(vm: viewModel)
        let viewController = NotificationViewController(view)
        window.contentViewController = viewController

        let shadowInset: CGFloat = 50

        let topRect = CGRect(
            x: screen.frame.origin.x,
            y: screen.frame.origin.y + screen.frame.height - viewModel.notificationOpenedSize.height - shadowInset - 24,
            width: screen.frame.width,
            height: viewModel.notificationOpenedSize.height + shadowInset // for shadow
        )
        window.window?.setFrameOrigin(topRect.origin)
        window.window?.setContentSize(topRect.size)

//        window.showWindow(nil)
        window.window?.orderFront(nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            viewModel.open()
        }

        viewModel.referencedWindow = window

        guard interval > 0 else { return }
        viewModel.scheduleClose(after: interval)
    }
}
