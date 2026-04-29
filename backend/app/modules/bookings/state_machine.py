"""
app/modules/bookings/state_machine.py
──────────────────────────────────────────────────────────────────
State machine for Booking lifecycle.
"""

class BookingStateMachine:
    VALID_TRANSITIONS = {
        "SEARCHING": ["ACCEPTED", "CANCELLED"],
        "ACCEPTED": ["EN_ROUTE", "CANCELLED"],
        "EN_ROUTE": ["ARRIVED", "CANCELLED"],
        "ARRIVED": ["IN_PROGRESS", "CANCELLED"],
        "IN_PROGRESS": ["COMPLETED"],
        "COMPLETED": [],
        "CANCELLED": []
    }

    @classmethod
    def can_transition(cls, current_status: str, new_status: str) -> bool:
        allowed_next_states = cls.VALID_TRANSITIONS.get(current_status, [])
        return new_status in allowed_next_states

    @classmethod
    def validate_transition(cls, current_status: str, new_status: str):
        if not cls.can_transition(current_status, new_status):
            raise ValueError(f"Invalid transition from {current_status} to {new_status}")
