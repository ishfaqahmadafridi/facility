import { useState, useEffect } from 'react'
import { feedService } from '../services/api'

export const useJobs = (shouldFetch) => {
    const [jobs, setJobs] = useState([])

    const fetchJobs = async () => {
        try {
            const res = await feedService.getJobs()
            setJobs(res.data)
        } catch (err) {
            console.error('Failed to fetch jobs', err)
        }
    }

    useEffect(() => {
        if (shouldFetch) {
            fetchJobs()
            const interval = setInterval(fetchJobs, 5000)
            return () => clearInterval(interval)
        }
    }, [shouldFetch])

    return jobs
}
