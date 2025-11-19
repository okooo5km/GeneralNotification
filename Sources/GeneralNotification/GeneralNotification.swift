// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@usableFromInline
let defaultInterval: TimeInterval = 2

public enum GeneralNotification {
    public static func present(
        bodyView: some View,
        interval: TimeInterval = defaultInterval,
        onTap: (() -> Void)? = nil
    ) {
        let bodyView =
            bodyView
            .font(.system(.body, design: .rounded))
            .frame(maxWidth: 320)

        guard
            let context = NotificationContext(
                bodyView: bodyView,
                onTap: onTap
            )
        else {
            return
        }

        context.open(forInterval: interval)
    }
}
