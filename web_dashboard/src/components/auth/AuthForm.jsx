import { motion } from 'framer-motion'

const AuthForm = ({ email, otp, loading, setEmail, setOtp, handleRequestOtp, handleVerifyOtp, token }) => (
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
)

export default AuthForm
