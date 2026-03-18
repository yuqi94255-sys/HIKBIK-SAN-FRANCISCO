// MARK: - Legal copy for in-app modals (keeps UI code clean)
import Foundation

enum LegalContentType: String, Identifiable {
    case terms = "Terms of Service"
    case privacy = "Privacy Policy"
    var id: String { rawValue }
}

enum LegalData {
    static let termsOfServiceTitle = "HIKBIK Terms of Service & Registration Agreement"

    static let termsOfService = """
    📜 HIKBIK TERMS OF SERVICE & REGISTRATION AGREEMENT

    Last Updated: March 3, 2026

    1. ACCEPTANCE OF TERMS
    By creating an account, accessing, or using the HIKBIK application ("App"), you ("User" or "Explorer") agree to be bound by these Terms of Service ("Terms") and our Privacy Policy. If you do not agree to these Terms, you may not register for an account or use the App. THESE TERMS CONTAIN A BINDING ARBITRATION CLAUSE AND CLASS ACTION WAIVER THAT IMPACT YOUR LEGAL RIGHTS.

    2. ACCOUNT REGISTRATION AND SECURITY
    To fully utilize HIKBIK, you must register for an account. You agree to:

    Provide accurate, current, and complete information (including a valid email address and legal name) during the registration process.

    Maintain the security and confidentiality of your password.

    Assume full responsibility for all activities that occur under your account.
    HIKBIK reserves the right to suspend or terminate accounts that provide inaccurate information or violate these Terms.

    3. ASSUMPTION OF RISK AND PHYSICAL SAFETY (CRITICAL)
    HIKBIK is a tool designed to enhance your outdoor exploration and track adventure statistics. However, outdoor activities (including but not limited to hiking, trekking, and mountaineering) carry inherent risks of property damage, severe bodily injury, or death.

    No Reliance on GPS: You acknowledge that GPS and location-based services are subject to environmental interference, battery failure, and software limitations. HIKBIK is NOT a substitute for professional wilderness navigation tools, physical maps, or emergency beacons.

    User Responsibility: You are solely responsible for your own safety, health conditions, route planning, and compliance with local laws and park regulations.

    4. USER CONDUCT AND PROHIBITED ACTIVITIES
    While using HIKBIK, you agree NOT to:

    Trespass on private property or enter restricted/dangerous geographic areas while using the App.

    Use the App for any illegal, harassing, or unauthorized surveillance purposes.

    Reverse engineer, decompile, or attempt to extract the source code of the App.

    5. INTELLECTUAL PROPERTY
    All content, features, and functionality of the App (including but not limited to the HIKBIK name, logo, neon UI design, and digital medals) are the exclusive property of HIKBIK and are protected by international copyright and trademark laws. Users retain ownership of their personal adventure data and user-generated content, but grant HIKBIK a worldwide, non-exclusive license to use, display, and process this data to provide the Service.

    6. DISCLAIMER OF WARRANTIES
    THE APP IS PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS. HIKBIK EXPRESSLY DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. HIKBIK DOES NOT GUARANTEE THE ACCURACY, COMPLETENESS, OR TIMELINESS OF ANY LOCATION DATA OR ADVENTURE STATISTICS PROVIDED.

    7. LIMITATION OF LIABILITY
    TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL HIKBIK, ITS FOUNDERS, DIRECTORS, EMPLOYEES, OR AFFILIATES BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING BUT NOT LIMITED TO LOSS OF DATA, PERSONAL INJURY, OR PROPERTY DAMAGE, ARISING OUT OF OR IN CONNECTION WITH YOUR USE OF THE APP.

    8. GOVERNING LAW AND DISPUTE RESOLUTION
    These Terms shall be governed by and construed in accordance with the laws of the State of Delaware, United States, without regard to its conflict of law provisions. Any dispute arising from these Terms shall be resolved through binding arbitration in the United States, and you waive your right to participate in a class-action lawsuit.

    9. MODIFICATIONS TO TERMS
    HIKBIK reserves the right to modify these Terms at any time. We will notify users of significant changes via the email associated with their account or through an in-app notification. Continued use of the App after such changes constitutes acceptance of the new Terms.
    """

    static let privacyPolicyTitle = "Privacy Policy"

    static let privacyPolicy = """
    HIKBIK Privacy Policy

    Last Updated: March 3, 2026

    Your privacy is important to us. This Privacy Policy describes how HIKBIK collects, uses, and protects your information when you use our App. By using HIKBIK, you agree to the practices described in this policy and in our Terms of Service.

    For full details on data handling, account security, and your rights, please refer to the Terms of Service and any supplementary privacy notices provided in the App or via email.
    """
}
