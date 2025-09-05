import SwiftUI
@available(iOS 17.0, *)
struct SnapCarousel<T, Content: View>: View {
    private var pageIndicatorSpacing: CGFloat {
        pageIndicatorHidden ? .zero : 16
    }
    private var pageIndicatorHeight: CGFloat {
        pageIndicatorHidden ? .zero : 8
    }
    private let interItemSpacing: CGFloat = 0
    private let horizontalPadding: CGFloat
    private let models: [T]
    private let pageIndicatorHidden: Bool
    @Binding private var scrollID: Int?
    private var parentViewWidth: CGFloat
    @ViewBuilder private let content: (T) -> Content
    init(
        selectedIndex: Binding<Int?>,
        parentViewWidth: CGFloat,
        horizontalPadding: CGFloat = 8,
        models: [T],
        pageIndicatorHidden: Bool = false,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        _scrollID = selectedIndex
        self.parentViewWidth = parentViewWidth
        self.horizontalPadding = horizontalPadding
        self.models = models
        self.pageIndicatorHidden = pageIndicatorHidden
        self.content = content
    }
    var body: some View {
        let width = parentViewWidth - (horizontalPadding * 2)
        let height = AspectRatio.getSizeForHD2RatioFrom(width).height
        let size = CGSize(width: width, height: height)
        return VStack(spacing: pageIndicatorSpacing) {
            carousel(size)
            if !pageIndicatorHidden {
                pageIndicator
            }
        }
        .frame(height: abs(height + pageIndicatorHeight + pageIndicatorSpacing))
    }
}
@available(iOS 17.0, *)
private extension SnapCarousel {
    func carousel(_ size: CGSize) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: interItemSpacing) {
                ForEach(Array(models.enumerated()), id: \.offset) { index, model in
                    content(model)
                        .frame(width: abs(size.width), height: abs(size.height))
                        .scrollTransition(.interactive, axis: .horizontal) { effect, phase in
                            effect
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                                .opacity(phase.isIdentity ? 1.0 : 0.5)
                        }
                        .id(index)
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, horizontalPadding)
        }
        .scrollPosition(id: $scrollID)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }
    var pageIndicator: some View {
        PageIndicatorView(count: models.count, scrollID: $scrollID)
    }
}
struct PageIndicatorView: View {
    let count: Int
    @Binding var scrollID: Int?
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == (scrollID ?? 0) ? DesignTokens.Brand.primary : DesignTokens.Text.secondary.opacity(0.3))
                    .frame(width: DesignTokens.Size.pageIndicatorSize, height: DesignTokens.Size.pageIndicatorSize)
            }
        }
    }
}
struct AspectRatio {
    static func getSizeForHD2RatioFrom(_ width: CGFloat) -> CGSize {
        let height = width * 9 / 16
        return CGSize(width: width, height: height)
    }
}
#Preview {
    VStack(spacing: .zero) {
        if #available(iOS 17.0, *) {
            let models = [0, 1, 2]
            SnapCarousel(
                selectedIndex: .constant(0),
                parentViewWidth: 320,
                models: models
            ) { index in
                RoundedRectangle(
                    cornerRadius: 15,
                    style: .continuous
                )
                .fill(index == 0 ? .red : .blue)
            }
        } else {
            Text("Not available iOS 17.0")
        }
    }
}
