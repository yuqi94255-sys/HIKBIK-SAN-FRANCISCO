// MARK: - 編輯個人資料（PATCH auth/me）
import SwiftUI

private let editProfileBioMaxLength = 100

private enum EditProfileTheme {
    static let background = Color(hex: "050A18")
    static let cardBg = Color(hex: "161C2C")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "8E8E93")
    static let accent = Color(hex: "3FFD98")
}

/// 與 `ProfileView` 共用 `ContentView` 注入的 `UserProfileViewModel.shared`；勿在此 `StateObject(UserProfileViewModel())`。
struct EditProfileSheet: View {
    @EnvironmentObject private var userProfileVM: UserProfileViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var bio: String = ""
    @State private var isSaving = false
    @State private var saveError: String?
    /// 進入時先從伺服器/本地載入，避免表單短暫顯示舊 mock（如 Apple 登錄）資料。
    @State private var isBootstrappingProfile = true

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First Name")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(EditProfileTheme.textMuted)
                            TextField("", text: $firstName)
                                .textContentType(.givenName)
                                .padding(14)
                                .background(EditProfileTheme.cardBg)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundStyle(EditProfileTheme.textPrimary)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Last Name")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(EditProfileTheme.textMuted)
                            TextField("", text: $lastName)
                                .textContentType(.familyName)
                                .padding(14)
                                .background(EditProfileTheme.cardBg)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundStyle(EditProfileTheme.textPrimary)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Bio")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(EditProfileTheme.textMuted)
                                Spacer()
                                Text("\(bio.count)/\(editProfileBioMaxLength)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(EditProfileTheme.textMuted)
                            }
                            ZStack(alignment: .topLeading) {
                                if bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    Text("Share a short intro…")
                                        .font(.system(size: 16))
                                        .foregroundStyle(EditProfileTheme.textMuted.opacity(0.6))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 12)
                                }
                                TextEditor(text: $bio)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 120)
                                    .padding(8)
                                    .background(EditProfileTheme.cardBg)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .foregroundStyle(EditProfileTheme.textPrimary)
                                    .onChange(of: bio) { _, newValue in
                                        if newValue.count > editProfileBioMaxLength {
                                            bio = String(newValue.prefix(editProfileBioMaxLength))
                                        }
                                    }
                            }
                        }
                    }
                    .padding(20)
                }
                .background(EditProfileTheme.background)
                .opacity(isBootstrappingProfile ? 0 : 1)
                .allowsHitTesting(!isBootstrappingProfile)

                if isBootstrappingProfile {
                    ProgressView("Loading profile…")
                        .tint(EditProfileTheme.accent)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(EditProfileTheme.background)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(EditProfileTheme.textMuted)
                    .disabled(isSaving || isBootstrappingProfile)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isSaving {
                        ProgressView()
                            .tint(EditProfileTheme.accent)
                    } else {
                        Button("Save") {
                            Task { await saveTapped() }
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(EditProfileTheme.accent)
                        .disabled(isBootstrappingProfile)
                    }
                }
            }
            .alert("Update failed", isPresented: Binding(
                get: { saveError != nil },
                set: { if !$0 { saveError = nil } }
            )) {
                Button("OK", role: .cancel) { saveError = nil }
            } message: {
                Text(saveError ?? "")
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await bootstrapProfileFieldsForEdit()
        }
    }

    /// 先拉遠端 `auth/me`，失敗則用本地 `UserDefaults` 快取，再填入表單。
    private func bootstrapProfileFieldsForEdit() async {
        await userProfileVM.refreshFromServerIfLoggedIn()
        await MainActor.run {
            if userProfileVM.profile == nil {
                userProfileVM.reloadFromStorage()
            }
            applyFieldsFromViewModel()
            isBootstrappingProfile = false
        }
    }

    private func applyFieldsFromViewModel() {
        guard let p = userProfileVM.profile else { return }
        firstName = p.firstName
        lastName = p.lastName
        bio = p.bio ?? ""
    }

    private func saveTapped() async {
        await MainActor.run {
            saveError = nil
            isSaving = true
        }
        let fn = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let ln = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let b = bio.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let response = try await AuthService.shared.updateProfile(firstName: fn, lastName: ln, bio: b)
            DispatchQueue.main.async {
                self.userProfileVM.profile = response.data
                self.isSaving = false
                self.dismiss()
            }
        } catch {
            await MainActor.run {
                isSaving = false
                saveError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }
}
