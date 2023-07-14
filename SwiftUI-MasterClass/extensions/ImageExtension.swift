import SwiftUI

extension Image {
    func fitImage() -> some View {
        resizable()
            .scaledToFit()
    }

    func fitIcon() -> some View {
        fitImage()
            .frame(maxWidth: 128)
            .foregroundColor(.purple)
            .opacity(0.5)
    }
}
