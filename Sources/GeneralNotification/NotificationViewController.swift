//
//  NotificationViewController.swift
//  GeneralNotification
//
//  Created by 十里 on 2024/10/04.
//

import AppKit
import Cocoa
import SwiftUI

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
}
