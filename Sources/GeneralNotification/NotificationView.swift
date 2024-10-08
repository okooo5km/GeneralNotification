//
//  NotificationView.swift
//  GeneralNotification
//
//  Created by 十里 on 2024/10/04.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var vm: NotificationViewModel

    @Environment(\.colorScheme)
    var systemColorScheme

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
            Group {
                if vm.status == .opened {
                    vm.bodyView
                        .frame(maxWidth: vm.notificationOpenedSize.width, maxHeight: vm.notificationOpenedSize.height)
                        .zIndex(1)
                        .background(
                            RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 2).foregroundStyle(
                                systemColorScheme == .dark ? Color.primary.opacity(0.2) : .white.opacity(0.3))
                        )
                        .background(.regularMaterial)
                        .focusable(false)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.5), radius: 10, y: 4)
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
}
