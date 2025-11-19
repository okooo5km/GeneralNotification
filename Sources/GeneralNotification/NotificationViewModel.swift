import Cocoa
import Combine
import Foundation
import SwiftUI

class NotificationViewModel: NSObject, ObservableObject {
    let notificationOpenedSize: CGSize

    let bodyView: AnyView

    let cornerRadius: CGFloat

    let onTap: (() -> Void)?

    var referencedWindow: NotificationWindowController? = nil

    init(screen: NSScreen, bodyView: AnyView, onTap: (() -> Void)? = nil) {
        self.bodyView = AnyView(bodyView.padding(8))
        self.onTap = onTap

        let bodyFittingSize = NSHostingView(rootView: self.bodyView).fittingSize

        notificationOpenedSize = .init(
            width: bodyFittingSize.width,
            height: max(bodyFittingSize.height, 0)
        )

        cornerRadius = min(notificationOpenedSize.height / 3, 16)

        super.init()
    }

    convenience init(screen: NSScreen, bodyView: some View, onTap: (() -> Void)? = nil) {
        self.init(
            screen: screen,
            bodyView: AnyView(bodyView),
            onTap: onTap
        )
    }

    let animation: Animation = .interactiveSpring(
        duration: 0.5,
        extraBounce: 0.25,
        blendDuration: 0.125
    )

    enum Status: String, Codable, Hashable, Equatable {
        case closed
        case opened
    }

    @Published private(set) var status: Status = .closed

    func open() {
        status = .opened
    }

    func close() { status = .closed }

    func scheduleClose(after interval: TimeInterval) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(destroy), with: nil, afterDelay: interval)
    }

    @objc func destroy() {
        close()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.destroyMemory()
        }
    }

    func destroyMemory() {
        referencedWindow?.window?.contentViewController = nil
        referencedWindow?.window?.close()
        referencedWindow?.close()
        referencedWindow = nil
    }
}
