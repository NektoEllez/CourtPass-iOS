import SwiftUI
struct BannerCardView: View {
    let title: String
    let buttonTitle: String
    let imageName: String
    init(title: String = "Upcoming Holidays soon", buttonTitle: String = "Call to action", imageName: String = "heart.fill") {
        self.title = title
        self.buttonTitle = buttonTitle
        self.imageName = imageName
    }
    var body: some View {
        HStack(spacing: 0) {
            leftContent
            rightContent
        }
        .frame(maxWidth: .infinity, maxHeight: DesignTokens.Banner.height)
        .background(DesignTokens.Banner.background)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.r16))
        .onTapGesture {
            HapticManager.shared.buttonTap()
            Task {
                await UIEventActor.shared.presentToast("Banner tapped")
            }
        }
    }
}
private extension BannerCardView {
    var leftContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .textCase(.uppercase)
                .font(DesignTokens.Typography.title)
                .foregroundColor(DesignTokens.Banner.titleText)
                .multilineTextAlignment(.leading)
                .lineLimit(DesignTokens.LineLimit.threeLines)
                .minimumScaleFactor(DesignTokens.Scale.minimumScale)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Button {
                HapticManager.shared.buttonTap()
                Task {
                    await UIEventActor.shared.presentToast("Coming soon")
                }
            } label: {
                Text(buttonTitle)
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Banner.buttonText)
                    .frame(maxWidth: DesignTokens.Banner.buttonMaxWidth)
                    .padding(.vertical, DesignTokens.Banner.buttonVerticalPadding)
                    .background(DesignTokens.Banner.buttonBackground)
                    .cornerRadius(DesignTokens.CornerRadius.r16)
            }
            .frame(alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, DesignTokens.Banner.leadingPadding)
        .padding(.vertical, DesignTokens.Banner.verticalPadding)
    }
    var rightContent: some View {
        VStack {
            Spacer()
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: DesignTokens.Banner.imageWidth)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.r12))
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
#Preview("Banner Card View") {
    BannerCardView()
        .padding()
}
