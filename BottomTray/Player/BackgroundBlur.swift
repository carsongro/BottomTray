//
//  BackgroundBlur.swift
//  BottomTray
//
//  Created by Carson Gross on 12/26/23.
//

import SwiftUI

fileprivate struct BackgroundBlob: View {
    @Environment(\.self) private var environment
    
    @State private var rotationAmount = 0.0
    @State private var color: Color
    
    private let alignment: Alignment = [.topLeading, .topTrailing, .bottomLeading, .bottomTrailing].randomElement()!
    
    var seedColor: CGColor
    
    init(seedColor: CGColor) {
        self.seedColor = seedColor
        _color = State(initialValue: Color(cgColor: seedColor))
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(
                width: .random(in: min(lowHeight, highHeight)...max(lowHeight, highHeight)),
                height: .random(in: min(lowHeight, highHeight)...max(lowHeight, highHeight))
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .offset(x: .random(in: -400...400), y: .random(in: -400...400))
            .rotationEffect(Angle(degrees: rotationAmount))
            .animation(.easeInOut(duration: .random(in: 15...30)).repeatForever(), value: rotationAmount)
            .onAppear {
                rotationAmount = .random(in: -360...360)
            }
            .blur(radius: 75)
            .onAppear {
                getColor()
                
                Task {
                    await getWidth()
                }
            }
    }
    
    @State private var lowHeight: CGFloat = 200
    @State private var highHeight: CGFloat = 500
    
    private func getWidth() async {
        let width = await UIScreen.main.bounds.size.width
        lowHeight = width * 0.5
        highHeight = width
    }
    
    @MainActor
    private func getColor() {
        let swiftUIColor = Color(cgColor: seedColor)
        let components = swiftUIColor.resolve(in: environment)
        let red = Double(components.red)
        let green = Double(components.green)
        let blue = Double(components.blue)
        let color = [
            swiftUIColor,
            Color(
                red: red + 0.2,
                green: green,
                blue: blue
            ),
            Color(
                red: red - 0.2,
                green: green,
                blue: blue
            )
        ].randomElement()!
        
        withAnimation {
            self.color = color
        }
    }
}

struct BackgroundBlurView: View {
    var seedColor: CGColor
    
    var body: some View {
        ZStack {
            ForEach(0..<24) { _ in
                BackgroundBlob(seedColor: seedColor)
            }
        }
        .background(.clear)
    }
}

#Preview {
    BackgroundBlurView(seedColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1))
}
