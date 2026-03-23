// MARK: - Login / Landing: one frosted glass card, in-place step switch (Email → Details → OTP)
import SwiftUI

private let neonGreen = Color(hex: "3FFD98")
private let cardNavy = Color(hex: "161C2C")
private let inputDark = Color(hex: "0D1117")
private let socialButtonBg = Color(hex: "1C1C1E").opacity(0.4)
private let placeholderGray = Color(hex: "A1A1A1")
private let inputTextWhite = Color.white
private let emailBorderDimBlue = Color(hex: "4A5A6E")
private let emailErrorRed = Color(hex: "E07A7A")
/// Spin: ultra-slim input background (very faint tint)
private let inputSlimBg = Color.white.opacity(0.05)

/// Step 1: Email +「下一步」分流 | Step 2: 老用戶密碼 / 新用戶註冊資料 | Step 3: 僅新用戶驗證碼
private enum FlowStep: Int {
    case email = 0
    case details = 1
    case otp = 2
}

// MARK: - Landing View (logo + unified card + guest link)
struct LandingView: View {
    var onContinueAsGuest: (() -> Void)?
    var onLoginSuccess: (() -> Void)?

    @State private var flowStep: FlowStep = .email

    var body: some View {
        BackgroundView {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer(minLength: 32)

                    UnifiedLoginCard(
                        flowStep: $flowStep,
                        onComplete: { onLoginSuccess?() },
                        onContinueAsGuest: onContinueAsGuest,
                        availableHeight: geo.size.height,
                        availableWidth: geo.size.width
                    )
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: geo.size.width * 0.9)
                    .padding(.horizontal, geo.size.width * 0.05)

                    Spacer(minLength: 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 56)
            }
            .animation(.easeInOut(duration: 0.3), value: flowStep.rawValue)
        }
        .ignoresSafeArea()
        .onAppear {
            AuthManager.shared.stripAuthTokenBeforeCredentialLogin()
        }
    }
}

// MARK: - Unified Card (one container, three steps with fade & slide)
private struct UnifiedLoginCard: View {
    @Binding var flowStep: FlowStep
    var onComplete: () -> Void
    var onContinueAsGuest: (() -> Void)?
    var availableHeight: CGFloat = UIScreen.main.bounds.height
    var availableWidth: CGFloat = UIScreen.main.bounds.width

    @State private var email = ""
    @State private var agreedToTerms = false
    @State private var receiveAlerts = true
    @FocusState private var isEmailFocused: Bool

    @State private var isExistingUser = false
    @State private var firstName = ""
    @State private var middleName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showPasswordError = false
    @FocusState private var detailsFocused: RegistrationField?

    @State private var otpCode = ""
    @State private var resendSeconds = 59
    @State private var showOTPSuccess = false
    @State private var showCheckmark = false
    @State private var showEmailError = false
    @State private var showTermsHint = false
    @State private var termsShakeOffset: CGFloat = 0
    @State private var isEmailVerified = false
    @State private var presentedLegalType: LegalContentType?
    @FocusState private var isOTPFocused: Bool
    @State private var otpTimer: Timer?

    /// 實時校驗：後端返回該郵箱已存在時為 true，輸入框紅框 + "Account already exists."
    @State private var emailAlreadyExists = false
    @State private var isCheckingEmail = false
    /// 註冊請求進行中，按鈕顯示 Loading，防止重複點擊
    @State private var isSubmittingDetails = false
    /// Email 步「下一步」：查詢 isExistingUser 或發送 OTP 進行中
    @State private var isEmailNextLoading = false
    @State private var sendOTPErrorMessage: String?
    /// 後端驗證 OTP 進行中
    @State private var isVerifyingOTP = false
    @State private var verifyOTPErrorMessage: String?
    /// 註冊報錯「Email already in use」時彈窗引導去登錄
    @State private var showAccountExistsAlert = false
    @State private var emailCheckTask: Task<Void, Never>?
    /// Step 2 登錄/註冊失敗提示
    @State private var detailsSubmitErrorMessage: String?

    private let otpLength = 6
    private let emailDebounceNanoseconds: UInt64 = 500_000_000 // 500ms

    /// Standard email regex (e.g. user@example.com)
    private static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#)
    private var isEmailValid: Bool {
        let t = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return !t.isEmpty && Self.emailPredicate.evaluate(with: t)
    }

    private var passwordMeetsRequirements: Bool {
        passwordRuleLength && passwordRuleLetter && passwordRuleNumber && passwordRuleSpecial
    }

    private var passwordRuleLength: Bool { password.count >= 8 }
    private var passwordRuleLetter: Bool { password.contains(where: { $0.isLetter }) }
    private var passwordRuleNumber: Bool { password.contains(where: { $0.isNumber }) }
    private static let specialChars = CharacterSet(charactersIn: "@$%!#&*()_+-=[]{}|;:'\",.<>?/\\~`")
    private var passwordRuleSpecial: Bool { password.unicodeScalars.contains(where: { Self.specialChars.contains($0) }) }

    /// Step 1：同意條款後可點「下一步」（由後端 `isExistingUser` 分流）
    private var canTapEmailNext: Bool {
        isEmailValid && agreedToTerms
    }

    /// Step 3（僅新用戶）：必須填滿 6 位且未在請求中，才可點「Verify」
    private var canTapVerifyOTP: Bool {
        otpCode.count == otpLength && !isVerifyingOTP
    }

    private var emailNextButtonTitle: String {
        if isEmailNextLoading { return "Loading…" }
        return "Next"
    }

    /// Step 2：老用戶僅密碼；新用戶需 OTP 通過後填寫註冊資料
    private var canSubmitDetails: Bool {
        let detailsOk: Bool
        if isExistingUser {
            detailsOk = !password.isEmpty
        } else {
            detailsOk = !firstName.trimmingCharacters(in: .whitespaces).isEmpty
                && !lastName.trimmingCharacters(in: .whitespaces).isEmpty
                && !password.isEmpty
                && password == confirmPassword
        }
        return detailsOk && agreedToTerms && (isExistingUser || isEmailVerified)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch flowStep {
            case .email:
                step1EmailContent
                    .frame(maxHeight: .infinity, alignment: .top)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .leading)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
            case .details:
                step2DetailsContent
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity
                    ))
            case .otp:
                step3OTPContent
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .bottom)),
                        removal: .opacity.combined(with: .move(edge: .bottom))
                    ))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            if flowStep == .otp && showOTPSuccess {
                otpSuccessOverlay
            }
        }
        .sheet(item: $presentedLegalType) { type in
            legalModal(for: type)
        }
        .alert("Account Exists", isPresented: $showAccountExistsAlert) {
            Button("Go to Log In") {
                isExistingUser = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("It looks like you already have an account. Would you like to Log In instead?")
        }
        .animation(.easeInOut(duration: 0.3), value: flowStep.rawValue)
    }

    /// 用戶停止輸入 500ms 後調用後端校驗該 Email 是否已存在，並更新 emailAlreadyExists
    private func scheduleEmailExistsCheck() {
        emailCheckTask?.cancel()
        emailCheckTask = Task {
            do {
                try await Task.sleep(nanoseconds: emailDebounceNanoseconds)
            } catch { return }
            guard !Task.isCancelled else { return }
            let current = email.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !current.isEmpty, Self.emailPredicate.evaluate(with: current) else { return }
            await MainActor.run { isCheckingEmail = true }
            let exists = await AuthService.checkEmailExists(email)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                emailAlreadyExists = exists
                isCheckingEmail = false
            }
        }
    }

    @ViewBuilder
    private func legalModal(for type: LegalContentType) -> some View {
        switch type {
        case .terms:
            LegalModal(
                title: LegalData.termsOfServiceTitle,
                content: LegalData.termsOfService,
                onDismiss: { presentedLegalType = nil }
            )
        case .privacy:
            LegalModal(
                title: LegalData.privacyPolicyTitle,
                content: LegalData.privacyPolicy,
                onDismiss: { presentedLegalType = nil }
            )
        }
    }

    // MARK: - Step 1: Email — Action Cluster centered ~40%, Terms at bottom, no truncation
    private var step1EmailContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Breathing room: at least 90pt from notch; Action Cluster starts ~40% from top
            Spacer(minLength: 0)
                .frame(height: max(90, availableHeight * 0.40 - 80))

            // Action Cluster: Email, Perks, Continue, Social — same width, vertically grouped
            VStack(alignment: .leading, spacing: 32) {
                // Email — width matches Continue button (both maxWidth: .infinity)
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .leading) {
                        TextField("", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .focused($isEmailFocused)
                            .foregroundStyle(inputTextWhite)
                            .onChange(of: email) { _, _ in
                                if showEmailError && isEmailValid { showEmailError = false }
                                emailAlreadyExists = false
                                scheduleEmailExistsCheck()
                            }
                        if email.isEmpty {
                            Text("Email")
                                .foregroundStyle(placeholderGray)
                                .allowsHitTesting(false)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 12).fill(inputSlimBg))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                emailAlreadyExists ? emailErrorRed : (isEmailValid ? neonGreen : (isEmailFocused ? neonGreen : Color.white.opacity(0.2))),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: emailAlreadyExists ? .clear : ((isEmailValid || isEmailFocused) ? neonGreen.opacity(0.35) : .clear), radius: 4)

                    if showEmailError {
                        Text("Please enter a valid email address.")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(emailErrorRed)
                    }
                    if emailAlreadyExists {
                        Text("Account already exists.")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(emailErrorRed)
                    }
                }
                .frame(maxWidth: .infinity)

                // Perks
                VStack(alignment: .leading, spacing: 8) {
                    Text("Join HIKBIK Explorer")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                    VStack(alignment: .leading, spacing: 6) {
                        BenefitRowCompact(icon: "chart.line.uptrend.xyaxis", text: "Pro Stats · Trail tracking")
                        BenefitRowCompact(icon: "medal.fill", text: "Digital Medals · Park badges")
                        BenefitRowCompact(icon: "lock.shield.fill", text: "Secure Sync · Cloud backup")
                    }
                }
                .padding(.horizontal, 4)
                .frame(maxWidth: .infinity, alignment: .leading)

                // 下一步：後端回傳 isExistingUser → 老用戶進密碼頁；新用戶發 OTP 進驗證碼頁
                Button(action: step1NextTapped) {
                    HStack(spacing: 10) {
                        if isEmailNextLoading {
                            ProgressView()
                                .tint(.black)
                        }
                        Text(emailNextButtonTitle)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle((canTapEmailNext && !isEmailNextLoading) ? .black : .black.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Capsule().fill((canTapEmailNext && !isEmailNextLoading) ? neonGreen : neonGreen.opacity(0.5)))
                }
                .buttonStyle(.plain)
                .disabled(!canTapEmailNext || isEmailNextLoading)
                .shadow(color: neonGreen.opacity((canTapEmailNext && !isEmailNextLoading) ? 0.5 : 0.25), radius: 10)
                .shadow(color: neonGreen.opacity((canTapEmailNext && !isEmailNextLoading) ? 0.3 : 0.15), radius: 20)

                if let msg = sendOTPErrorMessage {
                    Text(msg)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(emailErrorRed)
                }

                // Social — more padding between icons so they don’t look cramped
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        Rectangle().fill(Color.white.opacity(0.2)).frame(height: 1)
                        Text("or").font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(.white.opacity(0.5))
                        Rectangle().fill(Color.white.opacity(0.2)).frame(height: 1)
                    }
                    HStack(spacing: 36) {
                        SocialLoginButtonGhost(icon: "apple.logo", action: {
                            AuthManager.shared.mockAppleLogin()
                            onComplete()
                        })
                        SocialLoginButtonGhost(icon: "globe", action: {})
                        SocialLoginButtonGhost(icon: "person.2.fill", action: {})
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)

            Spacer(minLength: 24)

            // Continue as Guest — between social and terms
            if let guest = onContinueAsGuest {
                Button(action: guest) {
                    Text("Continue as Guest")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .buttonStyle(.plain)
            }

            Spacer(minLength: 24)

            // Terms & Privacy — tap opens LegalModal; links Neon Green
            VStack(alignment: .leading, spacing: 12) {
                Toggle(isOn: $agreedToTerms) {
                    TermsAndPrivacyLabel(
                        highlight: showTermsHint,
                        onTermsTapped: { presentedLegalType = .terms },
                        onPrivacyTapped: { presentedLegalType = .privacy }
                    )
                }
                .tint(neonGreen)
                .offset(x: termsShakeOffset)
                .onChange(of: showTermsHint) { _, newValue in
                    if newValue { triggerTermsShake() }
                }
                Toggle(isOn: $receiveAlerts) {
                    Text("Trek alerts & notifications")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .tint(neonGreen)
            }
            .padding(.bottom, 12)
        }
    }

    // MARK: - Step 2: Details (Register or Login)
    private var step2DetailsContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    isEmailVerified = false
                    isExistingUser = false
                    emailAlreadyExists = false
                    withAnimation(.easeInOut(duration: 0.3)) { flowStep = .email }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold))
                        Text("Back").font(.system(size: 16, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(.white.opacity(0.95))
                }
                .buttonStyle(.plain)

                Text(isExistingUser ? "Welcome back" : "Set up your account")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                if isExistingUser {
                    // 老用戶：密碼登入頁，Email 由上一步帶入、只讀展示
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(placeholderGray)
                        Text(email.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(inputTextWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(inputSlimBg))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                            )
                    }
                    .padding(.vertical, 4)
                    detailsLoginOnly
                } else {
                    HStack(spacing: 8) {
                        Text(email.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                            .lineLimit(1)
                        if isEmailVerified {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(neonGreen)
                                Text("Verified")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundStyle(neonGreen)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    detailsRegistration
                }

                // Terms — same as Step 1; tap opens LegalModal
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(isOn: $agreedToTerms) {
                        TermsAndPrivacyLabel(
                            highlight: showTermsHint,
                            onTermsTapped: { presentedLegalType = .terms },
                            onPrivacyTapped: { presentedLegalType = .privacy }
                        )
                    }
                    .tint(neonGreen)
                    .offset(x: termsShakeOffset)
                    .onChange(of: showTermsHint) { _, newValue in
                        if newValue { triggerTermsShake() }
                    }
                }

                detailsPrimaryButton
                if let err = detailsSubmitErrorMessage {
                    Text(err)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(emailErrorRed)
                }
                Button(action: { withAnimation(.easeOut(duration: 0.2)) { isExistingUser.toggle() } }) {
                    Text(isExistingUser ? "New user? Create an account" : "Already have an account? Log in")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var detailsRegistration: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                GlowTextField(placeholder: "First Name", text: $firstName, isFocused: detailsFocused == .firstName)
                    .focused($detailsFocused, equals: .firstName)
                GlowTextField(placeholder: "Last Name", text: $lastName, isFocused: detailsFocused == .lastName)
                    .focused($detailsFocused, equals: .lastName)
            }
            GlowTextField(placeholder: "Middle Name (Optional)", text: $middleName, isFocused: detailsFocused == .middleName)
                .focused($detailsFocused, equals: .middleName)

            PasswordFieldWithRequirements(
                placeholder: "Password",
                text: $password,
                isSecure: !showPassword,
                isFocused: detailsFocused == .password,
                showError: showPasswordError,
                onToggleVisibility: { showPassword.toggle() },
                lengthOk: passwordRuleLength,
                letterOk: passwordRuleLetter,
                numberOk: passwordRuleNumber,
                specialOk: passwordRuleSpecial
            )
            .focused($detailsFocused, equals: .password)
            .onChange(of: password) { _, _ in
                if showPasswordError && passwordMeetsRequirements { showPasswordError = false }
            }

            if showPasswordError {
                Text("Please meet the password requirements.")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(neonGreen)
            }

            PasswordField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: !showConfirmPassword, isFocused: detailsFocused == .confirm, onToggleVisibility: { showConfirmPassword.toggle() })
                .focused($detailsFocused, equals: .confirm)
        }
    }

    private var detailsLoginOnly: some View {
        VStack(alignment: .leading, spacing: 16) {
            PasswordField(placeholder: "Password", text: $password, isSecure: !showPassword, isFocused: detailsFocused == .password, onToggleVisibility: { showPassword.toggle() })
                .focused($detailsFocused, equals: .password)
            Button(action: {}) {
                Text("Forgot Password?")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(neonGreen)
            }
            .buttonStyle(.plain)
        }
    }

    @State private var createAccountPulse = false
    @State private var pulseTimer: Timer?

    private var detailsPrimaryButton: some View {
        Button(action: step2PrimaryTapped) {
            Group {
                if isSubmittingDetails {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(0.9)
                } else {
                    Text(isExistingUser ? "Log In" : "Create Account")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(canSubmitDetails ? .black : .black.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Capsule().fill(canSubmitDetails && !isSubmittingDetails ? neonGreen : neonGreen.opacity(0.5)))
        }
        .buttonStyle(.plain)
        .disabled(isSubmittingDetails)
        .scaleEffect(canSubmitDetails && createAccountPulse && !isSubmittingDetails ? 1.02 : 1.0)
        .shadow(color: neonGreen.opacity(canSubmitDetails ? 0.6 : 0.25), radius: canSubmitDetails ? 14 : 10)
        .shadow(color: neonGreen.opacity(canSubmitDetails ? 0.4 : 0.15), radius: canSubmitDetails ? 24 : 20)
        .animation(.easeInOut(duration: 0.6), value: createAccountPulse)
        .animation(.easeInOut(duration: 0.2), value: isSubmittingDetails)
        .onChange(of: canSubmitDetails) { _, ready in
            if ready {
                createAccountPulse = true
                pulseTimer?.invalidate()
                pulseTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { _ in
                    createAccountPulse.toggle()
                }
                RunLoop.main.add(pulseTimer!, forMode: .common)
            } else {
                pulseTimer?.invalidate()
                pulseTimer = nil
                createAccountPulse = false
            }
        }
        .onDisappear { pulseTimer?.invalidate(); pulseTimer = nil }
    }

    private func step2PrimaryTapped() {
        guard canSubmitDetails, !isSubmittingDetails else {
            if !agreedToTerms {
                showTermsHint = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { showTermsHint = false }
            }
            return
        }
        detailsSubmitErrorMessage = nil
        AuthManager.shared.stripAuthTokenBeforeCredentialLogin()
        if isExistingUser {
            isSubmittingDetails = true
            Task {
                do {
                    try await AuthService.login(
                        email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                        password: password
                    )
                    await MainActor.run {
                        AuthManager.shared.setLoggedIn(true)
                        isSubmittingDetails = false
                    }
                    await UserProfileViewModel.shared.refreshFromServerIfLoggedIn()
                    await MainActor.run {
                        onComplete()
                    }
                } catch {
                    await MainActor.run {
                        isSubmittingDetails = false
                        detailsSubmitErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                    }
                }
            }
            return
        }
        isSubmittingDetails = true
        Task {
            do {
                try await AuthService.register(
                    email: email,
                    firstName: firstName.trimmingCharacters(in: .whitespaces),
                    middleName: middleName.trimmingCharacters(in: .whitespaces),
                    lastName: lastName.trimmingCharacters(in: .whitespaces),
                    password: password
                )
                let profile = UserProfile(
                    firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                    lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines)
                )
                await MainActor.run {
                    UserProfileViewModel.shared.save(profile)
                    AuthManager.shared.setLoggedIn(true)
                    isSubmittingDetails = false
                }
                await UserProfileViewModel.shared.refreshFromServerIfLoggedIn()
                await MainActor.run {
                    onComplete()
                }
            } catch {
                await MainActor.run {
                    isSubmittingDetails = false
                    if isEmailAlreadyInUse(error) {
                        showAccountExistsAlert = true
                    } else {
                        detailsSubmitErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                    }
                }
            }
        }
    }

    // MARK: - Step 3: OTP (in-place, same screen; no navigation)
    private var step3OTPContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                isEmailVerified = false
                withAnimation(.easeInOut(duration: 0.3)) { flowStep = .email }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left").font(.system(size: 15, weight: .semibold))
                    Text("Edit Email").font(.system(size: 15, weight: .medium, design: .rounded))
                }
                .foregroundStyle(.white.opacity(0.95))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 6) {
                Text("Verify your Email")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("We've sent a 6-digit code to \(email.trimmingCharacters(in: .whitespacesAndNewlines)).")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }

            ZStack(alignment: .leading) {
                TextField("", text: $otpCode)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isOTPFocused)
                    .opacity(0.02)
                    .frame(height: 52)
                    .onChange(of: otpCode) { _, newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        otpCode = String(filtered.prefix(otpLength))
                        if verifyOTPErrorMessage != nil { verifyOTPErrorMessage = nil }
                    }
                HStack(spacing: 10) {
                    ForEach(0..<otpLength, id: \.self) { i in
                        otpDigitBox(i)
                    }
                }
            }
            .frame(maxWidth: .infinity)

            if let verifyErr = verifyOTPErrorMessage {
                Text(verifyErr)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(emailErrorRed)
            }

            Button(action: verifyOTPButtonTapped) {
                HStack(spacing: 10) {
                    if isVerifyingOTP {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .scaleEffect(0.9)
                    }
                    Text(isVerifyingOTP ? "Verifying…" : "Verify")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(canTapVerifyOTP ? .black : .black.opacity(0.5))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Capsule().fill(canTapVerifyOTP ? neonGreen : neonGreen.opacity(0.45)))
            }
            .buttonStyle(.plain)
            .disabled(!canTapVerifyOTP)

            Text(resendSeconds > 0 ? "Resend code in 00:\(String(format: "%02d", resendSeconds))" : "Resend code")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
        }
        .onAppear {
            isOTPFocused = true
            startOTPTimer()
        }
        .onDisappear { otpTimer?.invalidate() }
    }

    private func otpDigitBox(_ i: Int) -> some View {
        let active = i == otpCode.count || i < otpCode.count
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(inputSlimBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(active ? neonGreen : Color.white.opacity(0.2), lineWidth: active ? 2 : 1)
                )
                .shadow(color: active ? neonGreen.opacity(0.4) : .clear, radius: 6)
                .frame(width: 44, height: 52)
            if i < otpCode.count {
                Text(String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: i)]))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .onTapGesture { isOTPFocused = true }
    }

    private var otpSuccessOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack(spacing: 16) {
                Image(systemName: showCheckmark ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 64))
                    .foregroundStyle(neonGreen)
                    .scaleEffect(showCheckmark ? 1.1 : 0.8)
                Text("Verified!")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .transition(.opacity)
    }

    /// Email 步「下一步」：`GET auth/check-email` 得 `isExistingUser` → 老用戶進密碼頁；新用戶 `POST auth/send-otp` 後進驗證碼頁。
    private func step1NextTapped() {
        guard canTapEmailNext else {
            if !agreedToTerms {
                showTermsHint = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { showTermsHint = false }
            } else {
                showEmailError = true
            }
            return
        }
        guard !isEmailNextLoading else { return }
        showEmailError = false
        showTermsHint = false
        sendOTPErrorMessage = nil
        Task { @MainActor in
            isEmailNextLoading = true
            defer { isEmailNextLoading = false }
            do {
                let exists = try await AuthService.resolveEmailIsExistingUser(email)
                isExistingUser = exists
                emailAlreadyExists = exists
                if exists {
                    isEmailVerified = true
                    password = ""
                    confirmPassword = ""
                    withAnimation(.easeInOut(duration: 0.3)) { flowStep = .details }
                } else {
                    try await AuthService.sendOTP(email: email)
                    withAnimation(.easeInOut(duration: 0.3)) { flowStep = .otp }
                }
            } catch {
                sendOTPErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }

    private func triggerTermsShake() {
        let steps: [CGFloat] = [6, -6, 4, -4, 2, -2, 0]
        for (i, x) in steps.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.04) {
                withAnimation(.easeInOut(duration: 0.04)) { termsShakeOffset = x }
            }
        }
    }

    /// 僅新用戶到此步。`POST auth/verify-otp` 成功後進入註冊資料（密碼登入不經 OTP）。
    private func verifyOTPButtonTapped() {
        guard otpCode.count == otpLength, !isVerifyingOTP else { return }
        verifyOTPErrorMessage = nil
        Task { @MainActor in
            isVerifyingOTP = true
            defer { isVerifyingOTP = false }
            do {
                _ = try await AuthService.verifyOTP(email: email, code: otpCode)
                withAnimation(.easeOut(duration: 0.25)) { showOTPSuccess = true }
                try await Task.sleep(nanoseconds: 300_000_000)
                withAnimation(.easeOut(duration: 0.2)) { showCheckmark = true }
                try await Task.sleep(nanoseconds: 900_000_000)
                isEmailVerified = true
                showOTPSuccess = false
                showCheckmark = false
                otpCode = ""
                withAnimation(.easeInOut(duration: 0.3)) { flowStep = .details }
            } catch {
                if AuthService.isInvalidOrExpiredOTPError(error) {
                    verifyOTPErrorMessage = "Invalid Verification Code"
                } else {
                    verifyOTPErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                }
            }
        }
    }

    private func startOTPTimer() {
        resendSeconds = 59
        otpTimer?.invalidate()
        otpTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if resendSeconds > 0 { resendSeconds -= 1 } else { t.invalidate() }
        }
        RunLoop.main.add(otpTimer!, forMode: .common)
    }
}

// MARK: - Registration field focus
private enum RegistrationField: Hashable {
    case firstName, middleName, lastName, password, confirm
}

// MARK: - Helpers
private struct BenefitRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(neonGreen)
                .frame(width: 24, alignment: .center)
            Text(text)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct GlowTextField: View {
    let placeholder: String
    @Binding var text: String
    var isFocused: Bool
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text)
                .foregroundStyle(inputTextWhite)
            if text.isEmpty {
                Text(placeholder)
                    .foregroundStyle(placeholderGray)
                    .allowsHitTesting(false)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 12).fill(inputSlimBg))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isFocused ? neonGreen : Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: isFocused ? neonGreen.opacity(0.35) : .clear, radius: 4)
    }
}

private struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool
    var isFocused: Bool
    var onToggleVisibility: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .leading) {
                Group {
                    if isSecure { SecureField("", text: $text) }
                    else { TextField("", text: $text) }
                }
                .foregroundStyle(inputTextWhite)
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(placeholderGray)
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            Button(action: onToggleVisibility) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .buttonStyle(.plain)
            .padding(.trailing, 12)
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(inputSlimBg))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isFocused ? neonGreen : Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: isFocused ? neonGreen.opacity(0.35) : .clear, radius: 4)
    }
}

// MARK: - Password field + requirement lines (grey → neon green when met) + optional pulse error
private struct PasswordFieldWithRequirements: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool
    var isFocused: Bool
    var showError: Bool
    var onToggleVisibility: () -> Void
    var lengthOk: Bool
    var letterOk: Bool
    var numberOk: Bool
    var specialOk: Bool

    @State private var pulse = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PasswordField(placeholder: placeholder, text: $text, isSecure: isSecure, isFocused: isFocused, onToggleVisibility: onToggleVisibility)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(showError ? neonGreen : Color.clear, lineWidth: showError ? 2 : 0)
                )
                .scaleEffect(showError && pulse ? 1.015 : 1.0)
                .animation(pulse ? .easeInOut(duration: 0.18).repeatCount(2, autoreverses: true) : .default, value: pulse)

            Text("Password must be at least 8 characters long and include at least one letter, one number, and one special character (e.g., @, $, %, !, #).")
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .leading, spacing: 4) {
                requirementLine("At least 8 characters", met: lengthOk)
                requirementLine("One letter", met: letterOk)
                requirementLine("One number", met: numberOk)
                requirementLine("One special character (e.g., @, $, %, !, #)", met: specialOk)
            }
            .font(.system(size: 11, weight: .regular, design: .rounded))
        }
        .onChange(of: showError) { _, newValue in
            if newValue {
                pulse = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { pulse = false }
            }
        }
    }

    private func requirementLine(_ label: String, met: Bool) -> some View {
        Text(label)
            .foregroundStyle(met ? neonGreen : Color.white.opacity(0.45))
    }
}

private struct SocialLoginButton: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle().fill(socialButtonBg).background(Circle().fill(.ultraThinMaterial))
                )
                .overlay(Circle().strokeBorder(Color.white.opacity(0.35), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Terms label: Terms of Service & Privacy Policy open LegalModal (Neon Green)
private struct TermsAndPrivacyLabel: View {
    var highlight: Bool = false
    var onTermsTapped: (() -> Void)?
    var onPrivacyTapped: (() -> Void)?
    private let labelFont = Font.system(size: 11, weight: .regular, design: .rounded)
    private var textColor: Color { highlight ? .white : Color.white.opacity(0.7) }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Text("I agree to the ")
                    .font(labelFont)
                    .foregroundStyle(textColor)
                if let onTerms = onTermsTapped {
                    Button(action: onTerms) {
                        Text("Terms of Service")
                            .font(labelFont)
                            .foregroundStyle(neonGreen)
                    }
                    .buttonStyle(.plain)
                } else {
                    Link("Terms of Service", destination: URL(string: "https://hikbik.example/terms")!)
                        .font(labelFont)
                        .foregroundStyle(neonGreen)
                }
            }
            HStack(spacing: 4) {
                Text("and ")
                    .font(labelFont)
                    .foregroundStyle(textColor)
                if let onPrivacy = onPrivacyTapped {
                    Button(action: onPrivacy) {
                        Text("Privacy Policy")
                            .font(labelFont)
                            .foregroundStyle(neonGreen)
                    }
                    .buttonStyle(.plain)
                } else {
                    Link("Privacy Policy", destination: URL(string: "https://hikbik.example/privacy")!)
                        .font(labelFont)
                        .foregroundStyle(neonGreen)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Spin: compact benefit line + ghost social button
private struct BenefitRowCompact: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(neonGreen)
                .frame(width: 18, alignment: .center)
            Text(text)
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
        }
    }
}

private struct SocialLoginButtonGhost: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white.opacity(0.9))
                .frame(width: 52, height: 52)
                .overlay(Circle().strokeBorder(Color.white.opacity(0.4), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LandingView()
}
