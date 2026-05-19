import { Search } from 'lucide-react'
import JobCard from './JobCard'

const JobFeed = ({ jobs }) => (
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
                jobs.map((job) => <JobCard key={job._id} job={job} />)
            )}
        </div>
    </div>
)

export default JobFeed
