"""
app/modules/rides/state_machine.py
──────────────────────────────────────────────────────────────────
State machine to strictly enforce valid Ride lifecycle transitions.
"""

class RideStateMachine:
    VALID_TRANSITIONS = {
        "REQUESTED": ["BROADCASTING", "CANCELLED"],
        "BROADCASTING": ["NEGOTIATING", "CANCELLED"],
        "NEGOTIATING": ["MATCHED", "CANCELLED"],
        "MATCHED": ["CONFIRMED", "CANCELLED"],
        "CONFIRMED": ["IN_PROGRESS", "CANCELLED"],
        "IN_PROGRESS": ["COMPLETED"],
        "COMPLETED": [],
        "CANCELLED": []
    }

    @classmethod
    def can_transition(cls, current_status: str, new_status: str) -> bool:
        """Returns True if the transition is allowed."""
        allowed_next_states = cls.VALID_TRANSITIONS.get(current_status, [])
        return new_status in allowed_next_states

    @classmethod
    def validate_transition(cls, current_status: str, new_status: str):
        if not cls.can_transition(current_status, new_status):
            raise ValueError(f"Invalid transition from {current_status} to {new_status}")
