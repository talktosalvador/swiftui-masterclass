import SwiftUI

struct ButtonsAlignmentGradient: View {
    private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    private let colors = [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.7113229036, green: 0.4679040909, blue: 0.9639104009, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)), Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]
    private let url: String = "https://cdn-icons-png.flaticon.com/128/6941/6941697.png"
    private let cornerButtons = [
        CornerButton(name: "w", align: .topLeading),
        CornerButton(name: "x", align: .topTrailing),
        CornerButton(name: "y", align: .bottomLeading),
        CornerButton(name: "z", align: .bottomTrailing)
    ]
    @State private var start = UnitPoint(x: 0, y: 0)
    @State private var end = UnitPoint(x: 1, y: 1)
    @State var startAngle = 0
    @State var endAngle = 360
    @State var animationValue = 1

    var body: some View {
        ZStack {
            animatedLinearGradientBackground
                .ignoresSafeArea()

            centralButton

            alignedButtons
        }
    }

    // MARK: BACKGROUNDS

    var animatedLinearGradientBackground: some View {
        LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: start, endPoint: end)
            .animation(
                Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).speed(0.5),
                value: UUID()
            )
            .onReceive(timer, perform: { _ in
                start = UnitPoint(x: 0, y: 1)
                end = UnitPoint(x: 1, y: 0)
            })
    }

    var animatedAngularGradientBackground: some View {
        AngularGradient(
            gradient: Gradient(colors: colors),
            center: .center, startAngle: .degrees(Double(startAngle)),
            endAngle: .degrees(Double(endAngle))
        )
        .animation(
            Animation.easeInOut(duration: 2).repeatForever(autoreverses: true),
            value: animationValue
        )
        .onReceive(timer, perform: { _ in
            animationValue += 1
            startAngle += 20
            endAngle += 20
        })
        .blur(radius: 5)
    }

    // MARK: IMAGES

    var localImage: some View {
        Image("crown")
            .fitImage()
    }

    var simpleCloudImage: some View {
        AsyncImage(url: URL(string: url))
    }

    var scaledCloudImage: some View {
        AsyncImage(url: URL(string: url), scale: 0.5)
    }

    var placeholderCloudImage: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .fitImage()
        } placeholder: {
            Image(systemName: "photo.circle.fill")
                .fitIcon()
        }
    }

    var phaseCloudImage: some View {
        AsyncImage(
            url: URL(string: url),
            content: { phase in
                if let image = phase.image {
                    image
                        .fitImage()
                } else if phase.error != nil {
                    Image(systemName: "ant.circle.fill")
                        .fitIcon()
                } else {
                    Image(systemName: "photo.circle.fill")
                        .fitIcon()
                }
            }
        )
    }

    var animatedPhaseCloudImage: some View {
        AsyncImage(
            url: URL(string: url),
            transaction: Transaction(animation: .spring())
        ) { phase in
            switch phase {
            case .success(let image):
                image
                    .fitImage()
//                    .transition(.move(edge: .bottom))
//                    .transition(.slide)
                    .transition(.scale)
            case .failure:
                Image(systemName: "ant.circle.fill")
                    .fitIcon()
            case .empty:
                Image(systemName: "photo.circle.fill")
                    .fitIcon()
            @unknown default:
                ProgressView()
            }
        }
    }

    // MARK: CENTRAL BUTTON

    var centralButton: some View {
        Button { print("central") } label: {
            animatedPhaseCloudImage
        }
        .padding(40)
    }

    // MARK: CORNER BUTTONS

    var alignedButtons: some View {
        ForEach(cornerButtons) { button in
            Button { print(button.name) } label: {
                Text(button.name)
                    .padding()
            }
            .border(.black)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: button.align)
        }
    }
}

struct CornerButton: Identifiable {
    let id = UUID()
    let name: String
    let align: Alignment
}

struct ButtonsAlignmentGradient_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsAlignmentGradient()
    }
}
