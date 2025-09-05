import SwiftUI

struct DesignTokens {
    
    struct Brand {
        static let primary = Color(hex: "#EFF3FF")
        static let primaryPressed = Color(hex: "#0060DF")
        static let primaryPressedDark = Color(hex: "#4C8DFF")
    }
    
    struct TabBar {
        static let selected = Color(light: Color(hex: "#010C2D"), dark: Color(hex: "#FFFFFF"))
        static let unselected = Color(light: Color(hex: "#7585B7"), dark: Color(hex: "#8E8E93"))
        static let background = Color(.systemBackground)
    }
    
    struct Background {
        static let primary = Color("Background")
        static let secondary = Color(.secondarySystemBackground)
        static let card = Color(.tertiarySystemBackground)
    }
    
    struct Card {
        static let background = Color(.tertiarySystemBackground)
        static let contentBackground = Color(.systemBackground)
    }
    
    struct Banner {
        static let background = Color(red: 0.73, green: 0.26, blue: 0.28)
        static let titleText = Color.white.opacity(0.9)
        static let buttonBackground = Background.primary
        static let buttonText = Text.primary
        static let imageWidth: CGFloat = 150
        static let buttonMaxWidth: CGFloat = 118
        static let height: CGFloat = 150
        static let leadingPadding: CGFloat = 17
        static let verticalPadding: CGFloat = 19
        static let buttonVerticalPadding: CGFloat = 5
    }
    
    struct Text {
        // Primary text colors
        static let primary = Color.primary
        static let secondary = Color.secondary
        static let tertiary = Color(.tertiaryLabel)
        static let quaternary = Color(.quaternaryLabel)
        
        // Semantic text colors
        static let accent = Color.blue
        static let link = Color.blue
        static let disabled = Color.gray
        static let placeholder = Color(.placeholderText)
        
        // State colors for text
        static let success = State.success
        static let error = State.error  
        static let warning = State.warning
        
        // Inverted colors
        static let onDark = Color.white
        static let onLight = Color.black
    }
    
    struct Stroke {
        static let divider = Color(.separator)
    }
    
    struct State {
        static let success = Color(hex: "#34C759")
        static let error = Color(hex: "#FF3B30")
        static let warning = Color(hex: "#FF9F0A")
    }
    
    struct Typography {
        static let display = Font.yffRareTrialBold(size: 64)
        static let title = Font.yffRareTrialBold(size: 40)
        static let headline = Font.yffRareTrial(size: 17)
        
        static let body = Font.sfProDisplay(size: 17)
        static let subheadline = Font.sfProDisplay(size: 15)
        static let caption = Font.sfProDisplay(size: 13)
        static let callout = Font.sfProDisplaySemibold(size: 15)
        
        static let bodyMedium = Font.sfProDisplayMedium(size: 17)
        static let bodySemibold = Font.sfProDisplaySemibold(size: 17)
        static let bodyBold = Font.sfProDisplayBold(size: 17)
        
        static let displayFallback = Font.system(size: 28, weight: .semibold, design: .default)
        static let titleFallback = Font.system(size: 22, weight: .semibold, design: .default)
        static let headlineFallback = Font.system(size: 17, weight: .semibold, design: .default)
        static let bodyFallback = Font.system(size: 17, weight: .regular, design: .default)
        static let subheadlineFallback = Font.system(size: 15, weight: .regular, design: .default)
        static let captionFallback = Font.system(size: 13, weight: .regular, design: .default)
        static let calloutFallback = Font.system(size: 15, weight: .semibold, design: .default)
    }
    
    struct Spacing {
        // Base grid system
        static let baseGrid: CGFloat = 4
        
        // Standard spacing scale (based on 4pt grid)
        static let xs: CGFloat = 4      // 1x grid
        static let sm: CGFloat = 8      // 2x grid  
        static let md: CGFloat = 12     // 3x grid
        static let lg: CGFloat = 16     // 4x grid
        static let xl: CGFloat = 20     // 5x grid
        static let xxl: CGFloat = 24    // 6x grid
        static let xxxl: CGFloat = 32   // 8x grid
        
        // Semantic spacing
        static let screenPadding: CGFloat = lg
        static let blockSpacing: CGFloat = md
        static let innerSpacing: CGFloat = sm
        static let itemSpacing: CGFloat = sm
        
        // Control dimensions
        static let controlMinSize: CGFloat = 44
        static let controlHeight: CGFloat = 44
        static let buttonHeight: CGFloat = 48
        static let inputHeight: CGFloat = 44
        
        // Component specific
        static let tabBarHeight: CGFloat = 49
        static let navBarHeight: CGFloat = 44
        static let bannerHeight: CGFloat = 166
        static let cardPadding: CGFloat = lg
        static let sectionSpacing: CGFloat = xxl
        
        // Legacy aliases (deprecated - use semantic names)
        @available(*, deprecated, message: "Use lg instead")
        static let screenH: CGFloat = lg
        @available(*, deprecated, message: "Use md instead") 
        static let block: CGFloat = md
        @available(*, deprecated, message: "Use lg instead")
        static let inner: CGFloat = lg
        @available(*, deprecated, message: "Use controlMinSize instead")
        static let controls: CGFloat = controlMinSize
    }
    
    struct CornerRadius {
        // Standard radius scale
        static let none: CGFloat = 0
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let pill: CGFloat = 999  // For pill-shaped buttons
        
        // Semantic naming
        static let button: CGFloat = md
        static let card: CGFloat = lg
        static let input: CGFloat = sm
        static let modal: CGFloat = xl
        
        // Legacy aliases (deprecated)
        @available(*, deprecated, message: "Use md instead")
        static let r12: CGFloat = md
        @available(*, deprecated, message: "Use lg instead")
        static let r16: CGFloat = lg
    }
    
    struct Shadow {
        // Shadow colors with opacity
        static let light = Color.black.opacity(0.08)
        static let medium = Color.black.opacity(0.12)
        static let dark = Color.black.opacity(0.16)
        static let strong = Color.black.opacity(0.24)
        
        // Standard shadow configurations
        static let subtle = ShadowStyle(color: light, radius: 2, x: 0, y: 1)
        static let soft = ShadowStyle(color: medium, radius: 4, x: 0, y: 2) 
        static let regular = ShadowStyle(color: medium, radius: 8, x: 0, y: 4)
        static let prominent = ShadowStyle(color: dark, radius: 12, x: 0, y: 6)
        
        // Component specific shadows
        static let card = soft
        static let modal = prominent
        static let button = subtle
        static let tabBar = ShadowStyle(color: light, radius: 1, x: 0, y: -1)
        
        // Legacy (deprecated)
        @available(*, deprecated, message: "Use medium instead")
        static let offset = CGSize(width: 0, height: 2)
        @available(*, deprecated, message: "Use regular.radius instead")
        static let radius: CGFloat = 8
    }
    
    struct ShadowStyle {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
        
        var offset: CGSize { CGSize(width: x, height: y) }
    }
    
    struct Size {
        // Standard component sizes  
        static let buttonHeight: CGFloat = Spacing.buttonHeight
        static let inputHeight: CGFloat = Spacing.inputHeight
        static let tabBarHeight: CGFloat = Spacing.tabBarHeight
        
        // Card and image sizes
        static let categoryCardWidth: CGFloat = 80
        static let categoryCardHeight: CGFloat = 120
        static let categoryIconSize: CGFloat = 80
        
        // Gift card sizes
        static let heartButtonSize: CGFloat = 30
        static let heartIconSize: CGFloat = 12
        static let ratingBarHeight: CGFloat = 8
        
        // Banner sizes
        static let bannerImageWidth: CGFloat = 150
        static let bannerHeight: CGFloat = 150
        static let promoImageSize: CGFloat = 450
        static let flowerImageWidth: CGFloat = 200  
        static let flowerImageHeight: CGFloat = 280
        
        // Carousel indicators
        static let pageIndicatorSize: CGFloat = 8
    }
    
    struct Opacity {
        // Standard opacity levels
        static let disabled: Double = 0.3
        static let subtle: Double = 0.5
        static let medium: Double = 0.7
        static let strong: Double = 0.9
        
        // Overlay opacities
        static let loadingOverlay: Double = 0.3
        static let modalBackground: Double = 0.6
        
        // Component specific
        static let borderSubtle: Double = 0.3
        static let backgroundSubtle: Double = 0.08
    }
    
    struct LineLimit {
        static let singleLine: Int = 1
        static let twoLines: Int = 2 
        static let threeLines: Int = 3
        static let title: Int = twoLines
        static let description: Int = threeLines
    }
    
    struct Scale {
        // Transform scales
        static let buttonPressed: CGFloat = 0.95
        static let selectedTab: CGFloat = 1.1
        static let loading: CGFloat = 1.5
        static let minimumScale: CGFloat = 0.8
        static let none: CGFloat = 1.0
    }
    
    struct Animation {
        // Duration tokens
        static let instant: Double = 0.0
        static let fast: Double = 0.12
        static let normal: Double = 0.2 
        static let slow: Double = 0.3
        static let slower: Double = 0.5
        
        // Predefined animations
        static let snappy = SwiftUI.Animation.snappy(duration: normal)
        static let scale = SwiftUI.Animation.easeInOut(duration: fast)
        static let tabSelection = SwiftUI.Animation.easeInOut(duration: normal)
        static let loading = SwiftUI.Animation.linear(duration: slow)
    }
    
    struct Icons {
        static let search = "magnifyingglass"
        static let chevronDown = "chevron.down"
        static let gift = "gift.fill"
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let appleLogo = "apple.logo"
        static let googleCircle = "g.circle"
        
        static let tabGift = "0"
        static let tabGift1 = "1"
        static let tabCalendar = "2"
        static let tabCart = "3"
        static let tabProfile = "4"
    }
    
    struct IconSize {
        // Standard icon sizes (based on 4pt grid)
        static let xs: CGFloat = 12     // 3x grid
        static let sm: CGFloat = 16     // 4x grid
        static let md: CGFloat = 20     // 5x grid
        static let lg: CGFloat = 24     // 6x grid
        static let xl: CGFloat = 32     // 8x grid
        static let xxl: CGFloat = 40    // 10x grid
        
        // Semantic icon sizes
        static let tab: CGFloat = lg
        static let button: CGFloat = md
        static let heart: CGFloat = sm
        static let search: CGFloat = md
        static let chevron: CGFloat = xs
        static let social: CGFloat = lg
        
        // Component specific
        static let categoryIcon: CGFloat = 80
        static let giftCard: CGFloat = xl
        static let heartCircle: CGFloat = 30
        
        // Legacy aliases (deprecated)
        @available(*, deprecated, message: "Use chevron instead")
        static let chevronDown: CGFloat = chevron
        @available(*, deprecated, message: "Use giftCard instead") 
        static let gift: CGFloat = giftCard
        @available(*, deprecated, message: "Use social instead")
        static let appleLogo: CGFloat = social
        @available(*, deprecated, message: "Use button instead")
        static let magnifyingglass: CGFloat = button
        @available(*, deprecated, message: "Use chevron instead")
        static let chevronDownRange: ClosedRange<CGFloat> = 12...14
        @available(*, deprecated, message: "Use giftCard instead")
        static let giftFill: CGFloat = giftCard
        @available(*, deprecated, message: "Use heart instead")
        static let heartInCircle: CGFloat = heart
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    init(light: Color, dark: Color) {
        self = Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}

extension View {
    
    func primaryButtonStyle() -> some View {
        self
            .font(DesignTokens.Typography.body)
            .foregroundColor(.white)
            .frame(height: DesignTokens.Spacing.controlMinSize)
            .frame(maxWidth: .infinity)
            .background(DesignTokens.Brand.primary)
            .cornerRadius(DesignTokens.CornerRadius.r12)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Text.primary)
            .frame(height: DesignTokens.Spacing.controlMinSize)
            .frame(maxWidth: .infinity)
            .background(DesignTokens.Background.secondary)
            .cornerRadius(DesignTokens.CornerRadius.r12)
    }
    
    func borderedButtonStyle() -> some View {
        self
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Text.primary)
            .frame(height: DesignTokens.Spacing.controlMinSize)
            .frame(maxWidth: .infinity)
            .background(DesignTokens.Background.secondary)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.r12)
                    .stroke(DesignTokens.Stroke.divider, lineWidth: 1)
            )
    }
    
    func cardStyle() -> some View {
        self
            .background(DesignTokens.Background.card)
            .cornerRadius(DesignTokens.CornerRadius.r16)
            .shadow(
                color: DesignTokens.Shadow.light,
                radius: DesignTokens.Shadow.radius,
                x: DesignTokens.Shadow.offset.width,
                y: DesignTokens.Shadow.offset.height
            )
    }
    
    func searchFieldStyle() -> some View {
        self
            .font(DesignTokens.Typography.body)
            .frame(height: DesignTokens.Spacing.controlMinSize)
            .padding(.horizontal, DesignTokens.Spacing.innerSpacing)
            .background(DesignTokens.Background.secondary)
            .cornerRadius(DesignTokens.CornerRadius.r12)
    }
    
    func chipStyle(isSelected: Bool) -> some View {
        self
            .font(DesignTokens.Typography.callout)
            .foregroundColor(DesignTokens.Text.primary)
            .padding(.horizontal, DesignTokens.Spacing.innerSpacing)
            .padding(.vertical, DesignTokens.Spacing.innerSpacing)
            .background(
                isSelected 
                    ? DesignTokens.Text.primary.opacity(0.10)
                    : DesignTokens.Text.secondary.opacity(0.08)
            )
            .clipShape(Capsule())
    }
}

#Preview("Design Tokens") {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            Circle()
                .fill(DesignTokens.Brand.primary)
                .frame(width: 40, height: 40)
            
            Circle()
                .fill(DesignTokens.Background.secondary)
                .frame(width: 40, height: 40)
            
            Circle()
                .fill(DesignTokens.State.success)
                .frame(width: 40, height: 40)
        }
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Display Title")
                .font(DesignTokens.Typography.display)
            
            Text("Regular Title")
                .font(DesignTokens.Typography.title)
            
            Text("Headline Text")
                .font(DesignTokens.Typography.headline)
            
            Text("Body Text")
                .font(DesignTokens.Typography.body)
            
            Text("Caption Text")
                .font(DesignTokens.Typography.caption)
        }
        
        VStack(spacing: 12) {
            Button {
            } label: {
                Text("Primary Button")
            }
            .primaryButtonStyle()
            
            Button {
            } label: {
                Text("Secondary Button")
            }
            .secondaryButtonStyle()
            
            Button {
            } label: {
                Text("Bordered Button")
            }
            .borderedButtonStyle()
        }
        
        VStack {
            Text("Card Content")
                .font(DesignTokens.Typography.title)
            Text("This is a card with shadow and rounded corners")
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Text.secondary)
        }
        .padding()
        .cardStyle()
        
        HStack(spacing: 8) {
            Text("All")
                .chipStyle(isSelected: true)
            
            Text("Giftboxes")
                .chipStyle(isSelected: false)
            
            Text("For Her")
                .chipStyle(isSelected: false)
        }
    }
    .padding()
}
