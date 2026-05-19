import Navbar from './components/layout/Navbar'
import AuthForm from './components/auth/AuthForm'
import Sidebar from './components/layout/Sidebar'
import JobFeed from './components/job/JobFeed'
import { useJobs } from './hooks/useJobs'
import { useAuth } from './hooks/useAuth'
import { AnimatePresence } from 'framer-motion'

const App = () => {
    const auth = useAuth(), jobs = useJobs(auth.step === 'dashboard')
    const Content = auth.step === 'auth' ? <AuthForm {...auth} /> : <div className="grid grid-cols-1 lg:grid-cols-3 gap-8"><Sidebar email={auth.email} /><JobFeed jobs={jobs} /></div>
    return <div className="min-h-screen bg-[#0f172a] text-white p-4 font-sans"><Navbar /><main className="max-w-6xl mx-auto"><AnimatePresence mode="wait">{Content}</AnimatePresence></main></div>
}
export default App
