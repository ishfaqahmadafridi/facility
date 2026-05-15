class WorkerLogic:
    @staticmethod
    def get_categories():
        return {
            "Painter": ["Interior", "Exterior", "Texture", "Industrial"],
            "Labourer": ["Construction", "Moving", "Cleaning"],
            "Contractor": ["Home Renovation", "Civil Works", "Electrical"]
        }

    @staticmethod
    def calculate_experience_score(years: int, completed_jobs: int) -> float:
        # Senior logic for scoring workers
        return (years * 0.4) + (completed_jobs * 0.6)
