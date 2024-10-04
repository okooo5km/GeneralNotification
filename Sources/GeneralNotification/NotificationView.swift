//
//  NotificationView.swift
//  GeneralNotification
//
//  Created by 十里 on 2024/10/04.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var vm: NotificationViewModel

    var notificationSize: CGSize {
        switch vm.status {
        case .closed:
            .zero
        case .opened:
            vm.notificationOpenedSize
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            notification
                .zIndex(0)
                .disabled(true)
            Group {
                if vm.status == .opened {
                    vm.bodyView
                        .frame(maxWidth: vm.notificationOpenedSize.width, maxHeight: vm.notificationOpenedSize.height)
                        .zIndex(1)
                }
            }
            .transition(
                .scale.combined(
                    with: .opacity
                ).combined(
                    with: .offset(y: -vm.notificationOpenedSize.height / 2)
                ).animation(vm.animation)
            )
        }
        .padding()
        .animation(vm.animation, value: vm.status)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    var notification: some View {
        RoundedRectangle(cornerRadius: vm.cornerRadius)
            .stroke(.primary.opacity(0.1), lineWidth: 1)
            .background {
                RoundedRectangle(cornerRadius: vm.cornerRadius)
                    .fill(.thinMaterial)
            }
            .frame(
                width: notificationSize.width,
                height: notificationSize.height
            )
            .shadow(
                color: .black.opacity(([.opened].contains(vm.status)) ? 0.4 : 0),
                radius: 10,
                y: 5
            )
    }
}
