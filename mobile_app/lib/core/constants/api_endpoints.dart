/// Centralised API endpoint paths.
///
/// Every endpoint string lives here instead of being scattered across
/// [ApiService]. Paths are relative to the API v1 base URL.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String sendOtp = '/users/auth/send-otp/';
  static const String verifyOtp = '/users/auth/verify-otp/';
  static const String completeProfile = '/users/profile/complete/';
  static const String switchMode = '/users/switch-mode/';
  static const String toggleOnline = '/users/toggle-online/';
  static const String toggleRiderMode = '/users/toggle-rider-mode/';

  // ── User / Provider ───────────────────────────────────────────────────────
  static const String myProviderProfile = '/users/provider/me/';
  static String providerDetails(String id) => '/users/provider/$id/'; // Gap #7 fix: was /providers/

  // ── Jobs ───────────────────────────────────────────────────────────────────
  static const String categories = '/jobs/categories/';
  static const String providersNearby = '/jobs/providers-nearby/';
  static const String availableJobs = '/jobs/available/';
  static const String createJob = '/jobs/create/';
  static const String activeJobs = '/jobs/active/';
  static const String jobHistory = '/jobs/history/';
  static String acceptJob(String id) => '/jobs/$id/accept/';
  static String completeJob(String id) => '/jobs/$id/complete/'; // Gap #5

  // ── Rides ──────────────────────────────────────────────────────────────────
  static const String createRide = '/jobs/rides/create/';
  static const String availableRides = '/jobs/rides/available/';
  static String acceptRide(String id) => '/jobs/rides/$id/accept/';
  static String counterOfferRide(String id) => '/jobs/rides/$id/offer/';
  static String acceptCounterOffer(String id) => '/jobs/rides/$id/accept-counter/';
  static String declineCounterOffer(String id) => '/jobs/rides/$id/decline-counter/';

  // ── Portfolio (idea.odt §6, §11) ──────────────────────────────────────────
  static const String portfolio = '/jobs/portfolio/'; // Gap #3
  static String deletePortfolio(String id) => '/jobs/portfolio/$id/delete/'; // Gap #3

  // ── Reviews (idea.odt §6) ─────────────────────────────────────────────────
  static String createReview(String jobId) => '/jobs/$jobId/review/'; // Gap #3
  static String providerReviews(String providerId) => '/jobs/provider/$providerId/reviews/'; // Gap #3

  // ── Payments ───────────────────────────────────────────────────────────────
  static const String wallet = '/payments/wallet/';
  static const String withdraw = '/payments/withdraw/'; // Gap #6

  // ── Estimator (idea.odt §12) ──────────────────────────────────────────────
  static const String estimator = '/jobs/estimator/'; // Gap #4

  // ── Communication ──────────────────────────────────────────────────────────
  static const String sos = '/communication/sos/';
  static String chatHistory(String jobId) => '/communication/$jobId/messages/';
  static String sendMessage(String jobId) => '/communication/$jobId/send/';
  static String agoraToken(String jobId) => '/communication/$jobId/agora-token/';
  static String reportIssue(String jobId) => '/communication/job/$jobId/report/';
}

