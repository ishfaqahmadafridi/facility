/// User-facing strings used across the application.
///
/// Keeping all copy in one place makes localisation trivial later
/// and prevents typo-induced inconsistencies.
class AppStrings {
  AppStrings._();

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String invalidPhone =
      'Please enter a valid Pakistan phone number starting with +92';
  static const String invalidOtp = 'Please enter a valid 6-digit OTP';
  static const String otpSendFailed = 'Failed to send OTP. Please try again.';
  static const String otpResent = 'OTP resent';
  static const String otpInvalid = 'Invalid OTP';
  static const String profileCompleteFailed = 'Failed to complete profile';

  // ── Mode Switching ─────────────────────────────────────────────────────────
  static const String switchingMode = 'Switching Mode...';
  static const String switchModeFailed = 'Failed to switch mode.';
  static const String switchModeProviderFailed =
      'Failed to switch mode. Complete Provider Profile first!';

  // ── SOS ────────────────────────────────────────────────────────────────────
  static const String sosTriggered =
      'SOS triggered. Your live location has been shared with your emergency flow.';
  static const String sosFailed = 'Failed to trigger SOS.';

  // ── Jobs & Bookings ────────────────────────────────────────────────────────
  static const String jobAccepted = 'Job accepted!';
  static const String jobAcceptFailed = 'Failed to accept job.';
  static const String bookingConfirmedTitle = 'Booking Confirmed!';
  static const String bookingConfirmedMessage =
      'Your payment has been held securely in Escrow. Work can now begin.';
  static const String bookingFailed = 'Failed to create booking';
  static const String fillAllFields = 'Please fill all fields';

  // ── Rides ──────────────────────────────────────────────────────────────────
  static const String rideAccepted = 'Ride accepted at the suggested fare.';
  static const String rideAcceptFailed = 'Failed to accept ride.';
  static const String counterOfferSent = 'Counter-offer sent for customer approval.';
  static const String counterOfferFailed = 'Failed to send counter-offer.';
  static const String invalidOfferAmount = 'Enter a valid offer amount.';

  // ── Provider ───────────────────────────────────────────────────────────────
  static const String onlineNow = 'You are now Online!';
  static const String offlineNow = 'You are now Offline.';
  static const String onlineUpdateFailed = 'Failed to update online status.';
  static const String riderModeEnabled = 'Rider Mode enabled.';
  static const String riderModeDisabled = 'Rider Mode disabled.';
  static const String riderModeUpdateFailed = 'Failed to update Rider Mode.';
  static const String withdrawalComingSoon =
      'Withdrawal Request Screen coming soon!';

  // ── Chat & Communication ──────────────────────────────────────────────────
  static const String messageSendFailed = 'Failed to send message.';
  static const String voiceNoteFailed = 'Failed to send voice note.';
  static const String micPermissionRequired =
      'Microphone permission is required for voice notes.';
  static const String callConfigError =
      'Unable to start call. Check Agora backend configuration.';

  // ── Reports ────────────────────────────────────────────────────────────────
  static const String issueReported = 'Issue reported successfully.';
  static const String issueReportFailed = 'Failed to report issue.';
  static const String enterIssueDetails = 'Please enter the issue details.';
}
