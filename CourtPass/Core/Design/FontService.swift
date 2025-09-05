import SwiftUI
import UIKit


final class FontService {
    static let shared = FontService()
    
    private init() {}
    
    func registerCustomFonts() {
        let fontNames = [
            "YFFRARETRIAL-AlphaRegular",
            "YFFRARETRIAL-AlphaBold", 
            "YFFRARETRIAL-AlphaMedium",
            "YFFRARETRIAL-AlphaSemiBold",
            "YFFRARETRIAL-AlphaLight",
            "YFFRARETRIAL-AlphaExtraLight",
            "YFFRARETRIAL-AlphaThin",
            "YFFRARETRIAL-AlphaExtraBold",
            "YFFRARETRIAL-AlphaBlack"
        ]
        
        for fontName in fontNames {
            registerFont(named: fontName, fileExtension: "ttf")
        }
    }

    private func registerFont(named fontName: String, fileExtension: String) {
        let fontPath = "YFF RARE TRIAL Alpha/\(fontName)"
        guard let fontURL = Bundle.main.url(forResource: fontPath, withExtension: fileExtension),
              let fontData = NSData(contentsOf: fontURL),
              let provider = CGDataProvider(data: fontData),
              let font = CGFont(provider) else {
            
            if let fallbackURL = Bundle.main.url(forResource: fontName, withExtension: fileExtension),
               let fallbackData = NSData(contentsOf: fallbackURL),
               let fallbackProvider = CGDataProvider(data: fallbackData),
               let fallbackFont = CGFont(fallbackProvider) {
                var fallbackError: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(fallbackFont, &fallbackError) {
                    if let error = fallbackError {
                        _ = CFErrorCopyDescription(error.takeUnretainedValue())
                    }
                } else {
                }
            }
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            if let error = error {
                _ = CFErrorCopyDescription(error.takeUnretainedValue())
            }
        } else {
        }
    }
    
    
    func customFont(name: String, size: CGFloat) -> Font {
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        } else {
            return .system(size: size)
        }
    }
    
    func customUIFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}


extension Font {
    
    static func yffRareTrial(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaRegular", size: size)
    }
    
    static func yffRareTrialBold(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaBold", size: size)
    }
    
    static func yffRareTrialMedium(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaMedium", size: size)
    }
    
    static func yffRareTrialSemibold(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaSemiBold", size: size)
    }
    
    static func yffRareTrialLight(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaLight", size: size)
    }
    
    static func yffRareTrialExtraLight(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaExtraLight", size: size)
    }
    
    static func yffRareTrialThin(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaThin", size: size)
    }
    
    static func yffRareTrialExtraBold(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaExtraBold", size: size)
    }
    
    static func yffRareTrialBlack(size: CGFloat) -> Font {
        return FontService.shared.customFont(name: "YFFRARETRIAL-AlphaBlack", size: size)
    }
    
    
    static func sfProDisplay(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .regular, design: .default)
    }
    
    static func sfProDisplayMedium(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .medium, design: .default)
    }
    
    static func sfProDisplaySemibold(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .semibold, design: .default)
    }
    
    static func sfProDisplayBold(size: CGFloat) -> Font {
        return Font.system(size: size, weight: .bold, design: .default)
    }
}


extension UIFont {
    
    static func yffRareTrial(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaRegular", size: size)
    }
    
    static func yffRareTrialBold(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaBold", size: size)
    }
    
    static func yffRareTrialMedium(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaMedium", size: size)
    }
    
    static func yffRareTrialSemibold(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaSemiBold", size: size)
    }
    
    static func yffRareTrialLight(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaLight", size: size)
    }
    
    static func yffRareTrialExtraLight(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaExtraLight", size: size)
    }
    
    static func yffRareTrialThin(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaThin", size: size)
    }
    
    static func yffRareTrialExtraBold(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaExtraBold", size: size)
    }
    
    static func yffRareTrialBlack(size: CGFloat) -> UIFont {
        return FontService.shared.customUIFont(name: "YFFRARETRIAL-AlphaBlack", size: size)
    }
    
    
    static func sfProDisplay(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func sfProDisplayMedium(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func sfProDisplaySemibold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func sfProDisplayBold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
