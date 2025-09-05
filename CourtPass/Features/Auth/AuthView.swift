import SwiftUI


struct AuthView: View {
    @State private var isLoading = false
    let onSignInSuccess: () -> Void
    
    var body: some View {
        backgroundView
            .overlay {
                vectorBackground
                mainContent
                loadingOverlay
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
    
    
    @ViewBuilder
    private var backgroundView: some View {
        Color(.systemBackground).ignoresSafeArea()
    }
    
    @ViewBuilder
    private var vectorBackground: some View {
        VStack {
            Image("Vector")
                .resizable()
                .scaledToFill()
                .frame(width: DesignTokens.Size.promoImageSize, height: DesignTokens.Size.promoImageSize)
                .offset(y: DesignTokens.Spacing.xxxl * 2)
                .foregroundColor(Color(light: .white, dark: .gray))
                .opacity(0.15)
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 0) {
            skipButton
                .padding(.trailing, DesignTokens.Spacing.lg)
                .padding(.bottom, DesignTokens.Spacing.xl)
            welcomeSection.padding(.leading, DesignTokens.Spacing.lg)
            Spacer()
            flowerImage.padding(.bottom, DesignTokens.Spacing.xxxl + DesignTokens.Spacing.sm)
            authButtons
                .padding(.horizontal, DesignTokens.Spacing.lg)
            termsAndPrivacy
        }
    }
    
    @ViewBuilder
    private var skipButton: some View {
        HStack {
            Spacer()
            Button("Skip") {
                onSignInSuccess()
            }
            .font(DesignTokens.Typography.subheadline)
            .foregroundColor(DesignTokens.Text.secondary)
            .padding(.trailing, DesignTokens.Spacing.xl)
        }
    }
    
    @ViewBuilder
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("WELCOME")
                .font(DesignTokens.Typography.display)
                .foregroundColor(DesignTokens.Text.primary)
            
            Text("Enter your phone number. We will send you an SMS\nwith a confirmation code to this number.")
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Text.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, DesignTokens.Spacing.xxl)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var flowerImage: some View {
        Image("main_flower")
            .resizable()
            .scaledToFill()
            .frame(width: DesignTokens.Size.flowerImageWidth, height: DesignTokens.Size.flowerImageHeight)
    }
    
    @ViewBuilder
    private var authButtons: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            appleSignInButton
            googleSignInButton
        }
        .padding(.horizontal, DesignTokens.Spacing.xxl)
    }
    
    @ViewBuilder
    private var appleSignInButton: some View {
        Button {
            Task {
                await handleSignIn(provider: .apple)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "applelogo")
                    .font(.system(size: DesignTokens.IconSize.social, weight: .medium))
                    .foregroundColor(.black)
                
                Text("Continue with Apple")
                    .font(DesignTokens.Typography.bodySemibold)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.lg + DesignTokens.Spacing.xs)
            .background(.white)
            .cornerRadius(DesignTokens.CornerRadius.button)
        }
        .disabled(isLoading)
    }
    
    @ViewBuilder
    private var googleSignInButton: some View {
        Button {
            Task {
                await handleSignIn(provider: .google)
            }
        } label: {
            HStack(spacing: 12) {
                Image("google")
                    .font(.system(size: DesignTokens.IconSize.social, weight: .medium))
                    .foregroundColor(.black)
                
                Text("Continue with Google")
                    .font(DesignTokens.Typography.bodySemibold)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.lg + DesignTokens.Spacing.xs)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(DesignTokens.CornerRadius.button)
        }
        .disabled(isLoading)
    }
    
    @ViewBuilder
    private var termsAndPrivacy: some View {
        VStack(spacing: 4) {
            Text("By continuing, you agree to Assetsy's")
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Text.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: DesignTokens.Spacing.xs) {
                Button("Terms of Use") {
                    // Handle terms tap
                }
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Text.link)
                .underline()
                
                Text("and")
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(DesignTokens.Text.secondary)
                
                Button("Privacy Policy") {
                    // Handle privacy tap
                }
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Text.link)
                .underline()
            }
        }
        .padding(.horizontal, DesignTokens.Spacing.xxl)
        .padding(.top, DesignTokens.Spacing.xxl)
        .padding(.bottom, DesignTokens.Spacing.xxxl + DesignTokens.Spacing.lg)
    }
    
    @ViewBuilder
    private var loadingOverlay: some View {
        if isLoading {
            Color.black.opacity(DesignTokens.Opacity.loadingOverlay)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(DesignTokens.Scale.loading)
        }
    }
    
    
    private func handleSignIn(provider: SignInActor.Provider) async {
        isLoading = true
        
        await SignInActor.shared.signIn(provider: provider)
        
        await NavigationActor.shared.goToGifts()
        
        onSignInSuccess()
        
        isLoading = false
    }
}


#Preview("Auth View") {
    AuthView(onSignInSuccess: {})
}

#Preview("Auth View - Dark") {
    AuthView(onSignInSuccess: {})
        .preferredColorScheme(.dark)
}
