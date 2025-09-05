import SwiftUI

struct BannerImagesView: View {
    @Binding var currentBannerIndex: Int?
    
    var body: some View {
        GeometryReader { geometry in
            if #available(iOS 17.0, *) {
                SnapCarousel(
                    selectedIndex: $currentBannerIndex,
                    parentViewWidth: geometry.size.width,
                    horizontalPadding: DesignTokens.Spacing.screenH,
                    models: [0, 1],
                    pageIndicatorHidden: true
                ) { index in
                    if index == 0 {
                        BannerCardView()
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(DesignTokens.Text.disabled)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.r16)
                                )
                            
                            Text("Empty Card")
                                .font(DesignTokens.Typography.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            Task {
                                await UIEventActor.shared.presentToast("Empty banner tapped")
                            }
                        }
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        BannerCardView()
                            .frame(width: geometry.size.width - DesignTokens.Spacing.screenPadding * 2)
                        
                        ZStack {
                            Rectangle()
                                .fill(DesignTokens.Text.disabled)
                                .frame(width: geometry.size.width - DesignTokens.Spacing.screenPadding * 2, height: DesignTokens.Size.bannerHeight)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.r16)
                                )
                            
                            Text("Empty Card")
                                .font(DesignTokens.Typography.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            Task {
                                await UIEventActor.shared.presentToast("Empty banner tapped")
                            }
                        }
                    }
                    .padding(.leading, DesignTokens.Spacing.screenH)
                    .padding(.trailing, DesignTokens.Spacing.screenH * 0.5)
                }
                .scrollIndicators(.hidden)
            }
        }
        .frame(height: DesignTokens.Size.bannerHeight)
    }
}



#Preview("Banner Images View") {
    BannerImagesView(currentBannerIndex: .constant(0))
        .padding()
}
