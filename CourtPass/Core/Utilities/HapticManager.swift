import UIKit
import SwiftUI
@MainActor
@Observable
final class HapticManager {
    nonisolated static let shared = HapticManager()
    nonisolated private init() {}
    var isEnabled: Bool = true
    enum HapticType {
        case light
        case medium
        case heavy
        case selection
        case success
        case warning
        case error
        case soft
        case rigid
    }
    func impact(_ type: HapticType) {
        guard isEnabled else { return }
        switch type {
        case .light:
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.impactOccurred()
        case .medium:
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
        case .heavy:
            let feedback = UIImpactFeedbackGenerator(style: .heavy)
            feedback.impactOccurred()
        case .selection:
            let feedback = UISelectionFeedbackGenerator()
            feedback.selectionChanged()
        case .success:
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.success)
        case .warning:
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.warning)
        case .error:
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.error)
        case .soft:
            if #available(iOS 17.0, *) {
                let feedback = UIImpactFeedbackGenerator(style: .soft)
                feedback.impactOccurred()
            } else {
                let feedback = UIImpactFeedbackGenerator(style: .light)
                feedback.impactOccurred()
            }
        case .rigid:
            if #available(iOS 17.0, *) {
                let feedback = UIImpactFeedbackGenerator(style: .rigid)
                feedback.impactOccurred()
            } else {
                let feedback = UIImpactFeedbackGenerator(style: .heavy)
                feedback.impactOccurred()
            }
        }
    }
    func tabSelection() {
        impact(.selection)
    }
    func buttonTap() {
        impact(.light)
    }
    func favoriteToggle(isFavorite: Bool) {
        if isFavorite {
            impact(.success)
        } else {
            impact(.light)
        }
    }
    func success() {
        impact(.success)
    }
    func error() {
        impact(.error)
    }
    func warning() {
        impact(.warning)
    }
    func listSelection() {
        impact(.selection)
    }
    func scrollFeedback() {
        impact(.soft)
    }
    func importantAction() {
        impact(.rigid)
    }
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    func prepare(for type: HapticType) {
        guard isEnabled else { return }
        switch type {
        case .light, .soft:
            let feedback = UIImpactFeedbackGenerator(style: .light)
            feedback.prepare()
        case .medium:
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.prepare()
        case .heavy, .rigid:
            let feedback = UIImpactFeedbackGenerator(style: .heavy)
            feedback.prepare()
        case .selection:
            let feedback = UISelectionFeedbackGenerator()
            feedback.prepare()
        case .success, .warning, .error:
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
        }
    }
}
struct HapticFeedback: ViewModifier {
    let type: HapticManager.HapticType
    func body(content: Content) -> some View {
        content.onTapGesture {
            HapticManager.shared.impact(type)
        }
    }
}
extension View {
    func hapticFeedback(_ type: HapticManager.HapticType) -> some View {
        modifier(HapticFeedback(type: type))
    }
    func buttonHaptic() -> some View {
        hapticFeedback(.light)
    }
    func selectionHaptic() -> some View {
        hapticFeedback(.selection)
    }
}
@MainActor
protocol HapticEnabled {
    var hapticManager: HapticManager { get }
}
extension HapticEnabled {
    var hapticManager: HapticManager {
        HapticManager.shared
    }
}
