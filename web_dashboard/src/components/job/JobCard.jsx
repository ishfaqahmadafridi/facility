import { MapPin, Clock } from 'lucide-react'
import { motion } from 'framer-motion'

const JobCard = ({ job }) => (
    <motion.div
        initial={{ opacity: 0, x: 20 }}
        animate={{ opacity: 1, x: 0 }}
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
)

export default JobCard
