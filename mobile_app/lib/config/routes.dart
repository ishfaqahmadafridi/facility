// lib/config/routes.dart
import 'package:flutter/material.dart';

// SESSION 02
import '../src/modules/auth/screens/splash_screen.dart';
import '../src/modules/auth/screens/phone_entry_screen.dart';
import '../src/modules/auth/screens/otp_verification_screen.dart';
// SESSION 03
import '../src/modules/onboarding/screens/role_select_screen.dart';
import '../src/modules/home/screens/super_app_home.dart';
// SESSION 05
import '../src/modules/ride/screens/ride_map_screen.dart';
import '../src/modules/ride/screens/pick_drop_selector.dart';
import '../src/modules/ride/screens/ride_offer_screen.dart';
import '../src/modules/ride/screens/searching_drivers_screen.dart';
import '../src/modules/ride/screens/negotiation_chat_screen.dart';
import '../src/modules/ride/screens/ride_active_screen.dart';
// SESSION 06 - Booking
import '../src/modules/booking/screens/service_category_list.dart';
import '../src/modules/booking/screens/service_type_select.dart';
import '../src/modules/booking/screens/booking_form.dart';
import '../src/modules/booking/screens/provider_searching.dart';
import '../src/modules/booking/screens/job_tracking.dart';
// SESSION 06 - Nurses
import '../src/modules/nurses/screens/nurse_service_type.dart';
import '../src/modules/nurses/screens/subscription_plans.dart';
import '../src/modules/nurses/screens/visit_calendar.dart';
// SESSION 07 - Roadside
import '../src/modules/mechanics/screens/emergency_home.dart';
import '../src/modules/mechanics/screens/issue_type_select.dart';
import '../src/modules/mechanics/screens/mechanic_tracking.dart';
// SESSION 08 - Wallet
import '../src/modules/wallet/screens/wallet_dashboard.dart';
import '../src/modules/wallet/screens/top_up_screen.dart';
// SESSION 09 - Rating
import '../src/shared/screens/rating_screen.dart';
// SESSION 11 - Provider Panel
import '../src/modules/provider_panel/screens/provider_home.dart';
import '../src/modules/provider_panel/screens/job_card_detail.dart';
import '../src/modules/provider_panel/screens/navigate_to_job.dart';
import '../src/modules/provider_panel/screens/job_active.dart';
import '../src/modules/provider_panel/screens/earnings_dashboard.dart';
// Shared
import '../src/shared/screens/profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  // ── Route name constants ──────────────────────────────────────────
  static const String splash          = '/';
  static const String phoneEntry      = '/auth/phone';
  static const String otpVerification = '/auth/otp';
  static const String roleSelect      = '/onboarding/role';
  static const String permissions     = '/onboarding/permissions';
  static const String home            = '/home';

  // Ride (Session 05)
  static const String rideMap             = '/ride/map';
  static const String pickDrop            = '/ride/pick-drop';
  static const String rideOffer           = '/ride/offer';
  static const String searchingDrivers    = '/ride/searching';
  static const String negotiationChat     = '/ride/negotiation';
  static const String rideActive          = '/ride/active';

  // Booking (Session 06)
  static const String serviceCategories   = '/booking/categories';
  static const String serviceTypeSelect   = '/booking/service-type';
  static const String bookingForm         = '/booking/form';
  static const String providerSearching   = '/booking/searching';
  static const String jobTracking         = '/booking/tracking';

  // Nurses (Sessions 06 + 10)
  static const String nurseServiceType    = '/nurse/service-type';
  static const String subscriptionPlans   = '/nurse/plans';
  static const String visitCalendar       = '/nurse/calendar';

  // Roadside (Session 07)
  static const String emergencyHome       = '/roadside/emergency';
  static const String issueTypeSelect     = '/roadside/issue';
  static const String mechanicTracking    = '/roadside/tracking';

  // Wallet (Session 08)
  static const String walletDashboard     = '/wallet';
  static const String topUpScreen         = '/wallet/topup';

  // Shared (various sessions)
  static const String ratingScreen        = '/rating';
  static const String profile             = '/profile';

  // Provider panel (Session 11)
  static const String providerHome        = '/provider/home';
  static const String jobCardDetail       = '/provider/job-detail';
  static const String navigateToJob       = '/provider/navigate';
  static const String jobActive           = '/provider/job-active';
  static const String earningsDashboard   = '/provider/earnings';

  // ── Route map ─────────────────────────────────────────────────────
  static Map<String, WidgetBuilder> get routes => {
    // Core
    splash:           (_) => const SplashScreen(),
    phoneEntry:       (_) => const PhoneEntryScreen(),
    otpVerification:  (_) => const OtpVerificationScreen(),
    roleSelect:       (_) => const RoleSelectScreen(),
    home:             (_) => const SuperAppHome(),
    // Ride
    rideMap:          (_) => const RideMapScreen(),
    pickDrop:         (_) => const PickDropSelectorScreen(),
    rideOffer:        (context) => RideOfferScreen(rideId: ModalRoute.of(context)?.settings.arguments as String? ?? ''),
    searchingDrivers: (_) => const SearchingDriversScreen(),
    negotiationChat:  (_) => const NegotiationChatScreen(),
    rideActive:       (_) => const RideActiveScreen(),
    // Booking
    serviceCategories:  (_) => const ServiceCategoryListScreen(),
    serviceTypeSelect:  (_) => const ServiceTypeSelectScreen(),
    bookingForm:        (_) => const BookingFormScreen(),
    providerSearching:  (_) => const ProviderSearchingScreen(),
    jobTracking:        (_) => const JobTrackingScreen(),
    // Nurses
    nurseServiceType:   (_) => const NurseServiceTypeScreen(),
    subscriptionPlans:  (_) => const SubscriptionPlansScreen(),
    visitCalendar:      (_) => const VisitCalendarScreen(),
    // Roadside
    emergencyHome:      (_) => const EmergencyHomeScreen(),
    issueTypeSelect:    (_) => const IssueTypeSelectScreen(),
    mechanicTracking:   (_) => const MechanicTrackingScreen(),
    // Wallet
    walletDashboard:    (_) => const WalletDashboardScreen(),
    topUpScreen:        (_) => const TopUpScreen(),
    // Shared
    ratingScreen:       (_) => const RatingScreen(referenceId: '', revieweeId: '', referenceType: 'RIDE'),
    profile:            (_) => const ProfileScreen(),
    // Provider panel
    providerHome:       (_) => const ProviderHomeScreen(),
    jobCardDetail:      (_) => const JobCardDetailScreen(),
    navigateToJob:      (_) => const NavigateToJobScreen(),
    jobActive:          (_) => const JobActiveScreen(),
    earningsDashboard:  (_) => const EarningsDashboardScreen(),
  };
}
