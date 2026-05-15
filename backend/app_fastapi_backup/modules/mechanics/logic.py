class MechanicLogic:
    @staticmethod
    def get_vehicle_types():
        return ["Car", "Bike", "Heavy Truck", "Rickshaw"]

    @staticmethod
    def validate_eta(eta_minutes: int) -> bool:
        # Business rule: Rapid response mechanics must be within 120 mins
        return 5 <= eta_minutes <= 120

    @staticmethod
    def get_tools_checklist():
        return ["Diagnostic Scanner", "Wrench Set", "Jack", "Current Tester"]
