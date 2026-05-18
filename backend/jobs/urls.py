from django.urls import path
from .views import (CategoriesView, ProvidersNearbyView, AvailableJobsView,
                    CreateJobView, ProviderAcceptJobView, CustomerCompleteJobView,
                    CreateRideView, AvailableRidesView, RiderAcceptRideView,
                    RiderOfferRideView, CustomerAcceptCounterOfferView,
                    CustomerDeclineCounterOfferView, ActiveJobsView, JobHistoryView, EstimatorView)

urlpatterns = [
    path('categories/', CategoriesView.as_view(), name='categories'),
    path('providers-nearby/', ProvidersNearbyView.as_view(), name='providers_nearby'),
    path('available/', AvailableJobsView.as_view(), name='available_jobs'),
    path('create/', CreateJobView.as_view(), name='create_job'),
    path('<int:pk>/accept/', ProviderAcceptJobView.as_view(), name='accept_job'),
    path('<int:pk>/complete/', CustomerCompleteJobView.as_view(), name='complete_job'),
    path('rides/create/', CreateRideView.as_view(), name='create_ride'),
    path('rides/available/', AvailableRidesView.as_view(), name='available_rides'),
    path('rides/<int:pk>/accept/', RiderAcceptRideView.as_view(), name='accept_ride'),
    path('rides/<int:pk>/offer/', RiderOfferRideView.as_view(), name='offer_ride'),
    path('rides/<int:pk>/accept-counter/', CustomerAcceptCounterOfferView.as_view(), name='accept_counter_offer'),
    path('rides/<int:pk>/decline-counter/', CustomerDeclineCounterOfferView.as_view(), name='decline_counter_offer'),
    path('active/', ActiveJobsView.as_view(), name='active_jobs'),
    path('history/', JobHistoryView.as_view(), name='job_history'),
    path('estimator/', EstimatorView.as_view(), name='estimator'),
]
