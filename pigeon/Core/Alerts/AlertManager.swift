import SwiftUI
import Combine

final class AlertManager: ObservableObject {
    static let shared = AlertManager()
    
    @Published private(set) var currentAlert: PigeonAlert?
    @Published private(set) var isPresenting = false
    
    private var cancellables = Set<AnyCancellable>()
    private var dismissTimer: Timer?
    
    private init() {}
    
    func present(_ alert: PigeonAlert) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.currentAlert = alert
            self.isPresenting = true
            
            if !alert.requiresManualDismissal {
                self.scheduleDismissal(after: alert.style.displayDuration)
            }
        }
    }
    
    func present(
        message: String,
        title: String = "",
        style: AlertStyle = .info,
        requiresManualDismissal: Bool = false
    ) {
        let alert = GenericPigeonAlert(
            title: title.isEmpty ? style.defaultTitle : title,
            description: message,
            style: style,
            requiresManualDismissal: requiresManualDismissal
        )
        present(alert)
    }
    
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isPresenting = false
            self.dismissTimer?.invalidate()
            self.dismissTimer = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.currentAlert = nil
            }
        }
    }
    
    private func scheduleDismissal(after seconds: TimeInterval) {
        dismissTimer?.invalidate()
        dismissTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            self?.dismiss()
        }
    }
} 
