from datetime import datetime

class NurseLogic:
    @staticmethod
    def validate_hcs_id(hcs_id: str) -> bool:
        # Mock internal regulation check for HCS
        # In real life, call HCS API
        return len(hcs_id) > 5 and hcs_id.startswith("HCS-")

    @staticmethod
    def get_required_attestations() -> list:
        return ["PNMC License", "HCS Certificate", "Vaccination Record"]
