import { Layout as LayoutIcon, Briefcase, User } from 'lucide-react'

const Sidebar = ({ email }) => (
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
                    <LayoutIcon className="w-5 h-5" />
                    <span className="font-medium">Discover Jobs</span>
                </div>
                <div className="flex items-center gap-3 p-3 text-slate-400 hover:bg-white/5 rounded-xl cursor-pointer transition-colors">
                    <Briefcase className="w-5 h-5" />
                    <span className="font-medium">My Bids</span>
                </div>
            </nav>
        </div>
    </div>
)

export default Sidebar
