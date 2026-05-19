import { Bell } from 'lucide-react'

const Navbar = () => (
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
)

export default Navbar
