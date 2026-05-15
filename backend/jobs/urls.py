from django.urls import path
from .views import (CategoriesView, ProvidersNearbyView, AvailableJobsView,
                    CreateJobView, ProviderAcceptJobView, CustomerCompleteJobView,
                    CreateRideView, RiderAcceptRideView, ActiveJobsView, EstimatorView)

urlpatterns = [
    path('categories/', CategoriesView.as_view(), name='categories'),
    path('providers-nearby/', ProvidersNearbyView.as_view(), name='providers_nearby'),
    path('available/', AvailableJobsView.as_view(), name='available_jobs'),
    path('create/', CreateJobView.as_view(), name='create_job'),
    path('<int:pk>/accept/', ProviderAcceptJobView.as_view(), name='accept_job'),
    path('<int:pk>/complete/', CustomerCompleteJobView.as_view(), name='complete_job'),
    path('rides/create/', CreateRideView.as_view(), name='create_ride'),
    path('rides/<int:pk>/accept/', RiderAcceptRideView.as_view(), name='accept_ride'),
    path('active/', ActiveJobsView.as_view(), name='active_jobs'),
    path('estimator/', EstimatorView.as_view(), name='estimator'),
]
