"""
app/modules/matching/scorer.py
──────────────────────────────────────────────────────────────────
Scoring algorithm to rank nearby drivers.
"""

def score_providers(providers: list[dict]) -> list[dict]:
    """
    Ranks providers based on distance (and in a real app, rating/acceptance rate).
    `providers` is a list of dicts: [{"user_id": str, "distance_km": float, "lat": float, "lng": float}]
    """
    # Simple MVP scoring: shortest distance wins
    # Sort by distance ascending
    ranked = sorted(providers, key=lambda x: x['distance_km'])
    
    # Return top 10 for broadcasting
    return ranked[:10]
