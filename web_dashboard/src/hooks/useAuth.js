import { useState } from 'react'
import { authService } from '../services/api'

export const useAuth = () => {
    const [step, setStep] = useState('auth'), [email, setEmail] = useState(''), [otp, setOtp] = useState('')
    const [token, setToken] = useState(null), [loading, setLoading] = useState(false)

    const handleRequestOtp = async (e) => {
        e.preventDefault(); setLoading(true)
        try { await authService.requestOtp(email); alert('Code sent!') }
        catch { alert('Failed') } finally { setLoading(false) }
    }

    const handleVerifyOtp = async (e) => {
        e.preventDefault(); setLoading(true)
        try { 
            const res = await authService.verifyOtp(email, otp)
            setToken(res.data.access_token); setStep('dashboard')
        } catch { alert('Invalid') } finally { setLoading(false) }
    }

    return { step, email, otp, token, loading, setEmail, setOtp, handleRequestOtp, handleVerifyOtp }
}
