import axios from 'axios';

const api = axios.create({
    baseURL: 'http://localhost:8000',
});

// Interceptor to add JWT token to requests
api.interceptors.request.use((config) => {
    const token = localStorage.getItem('token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

export const authService = {
    requestOtp: (email) => api.post('/auth/request-otp', { email }),
    verifyOtp: (email, code) => api.post(`/auth/verify-otp?email=${email}&code=${code}`),
};

export const feedService = {
    getJobs: () => api.get('/feed/jobs'),
};

export default api;
