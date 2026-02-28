import { useState, useEffect } from 'react'
import { Layout, LogIn, Briefcase, User, Bell, Search, MapPin, Clock } from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import axios from 'axios'

const API_BASE = 'http://localhost:8000'

const App = () => {
    const [step, setStep] = useState('auth') // auth, dashboard
    const [email, setEmail] = useState('')
    const [otp, setOtp] = useState('')
    const [token, setToken] = useState(null)
    const [jobs, setJobs] = useState([])
    const [loading, setLoading] = useState(false)

    // Fetch jobs
    useEffect(() => {
        if (step === 'dashboard') {
            fetchJobs()
            const interval = setInterval(fetchJobs, 5000) // Poll every 5s
            return () => clearInterval(interval)
        }
    }, [step])

    const fetchJobs = async () => {
        try {
            const res = await axios.get(`${API_BASE}/feed/jobs`)
            setJobs(res.data)
        } catch (err) {
            console.error('Failed to fetch jobs', err)
        }
    }

    const handleRequestOtp = async (e) => {
        e.preventDefault()
        setLoading(true)
        try {
            await axios.post(`${API_BASE}/auth/request-otp`, { email })
            alert('Verification code sent to email!')
        } catch (err) {
            alert('Failed to send code')
        } finally {
            setLoading(false)
        }
    }

    const handleVerifyOtp = async (e) => {
        e.preventDefault()
        setLoading(true)
        try {
            const res = await axios.post(`${API_BASE}/auth/verify-otp?email=${email}&code=${otp}`)
            setToken(res.data.access_token)
            setStep('dashboard')
        } catch (err) {
            alert('Invalid code')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="min-h-screen bg-[#0f172a] text-white p-4 font-sans">
            <nav className="max-w-6xl mx-auto flex justify-between items-center py-6 mb-12">
                <div className="flex items-center gap-2">
                    <div className="w-10 h-10 bg-blue-600 rounded-xl flex items-center justify-center font-bold text-xl">F</div>
                    <span className="text-2xl font-bold tracking-tight">Facility</span>
                </div>
                <div className="flex gap-4">
                    <Bell className="w-6 h-6 text-slate-400 cursor-pointer hover:text-white transition-colors" />
                    <div className="w-8 h-8 rounded-full bg-slate-800 border border-slate-700" />
                </div>
            </nav>

            <main className="max-w-6xl mx-auto">
                <AnimatePresence mode="wait">
                    {step === 'auth' ? (
                        <motion.div
                            key="auth"
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            exit={{ opacity: 0, y: -20 }}
                            className="max-w-md mx-auto mt-20"
                        >
                            <div className="glass-card p-8 bg-white/5 border border-white/10 rounded-3xl">
                                <h1 className="text-3xl font-bold mb-2">Welcome Back</h1>
                                <p className="text-slate-400 mb-8">Sign in to your professional marketplace</p>

                                <form className="space-y-6">
                                    <div>
                                        <label className="block text-sm font-medium text-slate-400 mb-2">Email Address</label>
                                        <input
                                            type="email"
                                            value={email}
                                            onChange={(e) => setEmail(e.target.value)}
                                            className="w-full bg-slate-900 border border-slate-700 rounded-xl p-4 focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                                            placeholder="name@example.com"
                                        />
                                    </div>

                                    {email && (
                                        <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: 'auto' }}>
                                            <label className="block text-sm font-medium text-slate-400 mb-2">Verification Code</label>
                                            <input
                                                type="text"
                                                value={otp}
                                                onChange={(e) => setOtp(e.target.value)}
                                                className="w-full bg-slate-900 border border-slate-700 rounded-xl p-4 focus:ring-2 focus:ring-blue-500 outline-none"
                                                placeholder="Enter 6-digit code"
                                            />
                                        </motion.div>
                                    )}

                                    {!token ? (
                                        <button
                                            onClick={otp ? handleVerifyOtp : handleRequestOtp}
                                            disabled={loading}
                                            className="w-full btn-primary bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 rounded-xl shadow-lg shadow-blue-500/20 transition-all active:scale-95 disabled:opacity-50"
                                        >
                                            {loading ? 'Processing...' : (otp ? 'Verify & Continue' : 'Get Verification Code')}
                                        </button>
                                    ) : null}
                                </form>
                            </div>
                        </motion.div>
                    ) : (
                        <motion.div
                            key="dashboard"
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            className="grid grid-cols-1 lg:grid-cols-3 gap-8"
                        >
                            {/* Sidebar Menu */}
                            <div className="lg:col-span-1 space-y-6">
                                <div className="glass-card p-6 bg-white/5 border border-white/10 rounded-3xl">
                                    <div className="flex items-center gap-4 mb-8">
                                        <div className="w-12 h-12 rounded-full bg-blue-600/20 flex items-center justify-center">
                                            <User className="text-blue-500" />
                                        </div>
                                        <div>
                                            <h3 className="font-bold">{email.split('@')[0]}</h3>
                                            <p className="text-slate-400 text-sm">Customer Profile</p>
                                        </div>
                                    </div>
                                    <nav className="space-y-4">
                                        <div className="flex items-center gap-3 p-3 bg-blue-600/10 text-blue-400 rounded-xl cursor-pointer">
                                            <Layout className="w-5 h-5" />
                                            <span className="font-medium">Discover Jobs</span>
                                        </div>
                                        <div className="flex items-center gap-3 p-3 text-slate-400 hover:bg-white/5 rounded-xl cursor-pointer transition-colors">
                                            <Briefcase className="w-5 h-5" />
                                            <span className="font-medium">My Bids</span>
                                        </div>
                                    </nav>
                                </div>
                            </div>

                            {/* Job Feed */}
                            <div className="lg:col-span-2 space-y-6">
                                <div className="flex justify-between items-center mb-4">
                                    <h2 className="text-2xl font-bold">Featured Jobs</h2>
                                    <div className="bg-slate-800 p-2 px-4 rounded-lg flex items-center gap-2 text-sm text-slate-400">
                                        <Search className="w-4 h-4" />
                                        <span>Search services...</span>
                                    </div>
                                </div>

                                <div className="space-y-4">
                                    {jobs.length === 0 ? (
                                        <div className="p-12 text-center text-slate-500 glass-card">
                                            No active jobs in your area yet.
                                        </div>
                                    ) : (
                                        jobs.map((job) => (
                                            <motion.div
                                                initial={{ opacity: 0, x: 20 }}
                                                animate={{ opacity: 1, x: 0 }}
                                                key={job._id}
                                                className="glass-card p-6 bg-white/5 hover:bg-white/10 border border-white/10 rounded-3xl transition-all cursor-pointer group"
                                            >
                                                <div className="flex justify-between items-start mb-4">
                                                    <div>
                                                        <span className="inline-block px-3 py-1 bg-blue-600/10 text-blue-500 text-xs font-bold rounded-full mb-3 uppercase tracking-wider">
                                                            {job.category}
                                                        </span>
                                                        <h3 className="text-xl font-bold group-hover:text-blue-400 transition-colors">{job.sub_category}</h3>
                                                    </div>
                                                    <div className="text-right">
                                                        <span className="text-2xl font-bold text-green-400">Rs. {job.budget || 'Bidding'}</span>
                                                        <p className="text-slate-400 text-xs mt-1">Starting Price</p>
                                                    </div>
                                                </div>
                                                <p className="text-slate-400 text-sm mb-6 line-clamp-2">{job.description}</p>
                                                <div className="flex items-center gap-6 text-xs text-slate-500 pt-6 border-t border-white/10">
                                                    <div className="flex items-center gap-1">
                                                        <MapPin className="w-4 h-4" />
                                                        <span>Islamabad, PK</span>
                                                    </div>
                                                    <div className="flex items-center gap-1">
                                                        <Clock className="w-4 h-4" />
                                                        <span>Post 2h ago</span>
                                                    </div>
                                                </div>
                                            </motion.div>
                                        ))
                                    )}
                                </div>
                            </div>
                        </motion.div>
                    )}
                </AnimatePresence>
            </main>
        </div>
    )
}

export default App
