//
//  App.swift
//  GeneralNotification
//
//  Created by 秋星桥 on 2024/9/19.
//

import GeneralNotification
import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView
                .background(.ultraThinMaterial)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }

    @State var title: String = "Notification Title ✨"
    @State var message: String = "This is general customized notification!"
    @State var interval: TimeInterval = 3 {
        didSet { if interval < 0 { interval = 0 } }
    }

    var ContentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("General Notification")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "questionmark.circle")
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://github.com/okooo5km/GeneralNotification")!)
                    }
            }
            
            TextField("Title", text: $title)
                .frame(minWidth: 240)
            
            TextField("Message", text: $message)
                .frame(minWidth: 240)
            
            HStack {
                Group {
                    if interval <= 0 {
                        Text("inf")
                    } else {
                        Text("\(Int(interval)) s")
                    }
                }
                .frame(width: 24, alignment: .leading)
                
                Button("-") { interval -= 1 }
                    .disabled(interval <= 0)
                
                Button("+") { interval += 1 }
                    .disabled(interval >= 16)
                
                Spacer()
                
                Button("Message") {
                    GeneralNotification.present(
                        bodyView: HStack {
                            Image(nsImage: NSApplication.shared.applicationIconImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 48, height: 48)
                            
                            VStack(alignment: .leading) {
                                Text(title)
                                    .font(.headline)
                                Text(message)
                                    .font(.caption)
                            }
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: 16))
                                .padding(8)
                        },
                        interval: interval
                    )
                }
            }
        }
        .padding(16)
    }
}
