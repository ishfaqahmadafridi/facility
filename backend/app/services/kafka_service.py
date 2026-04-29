"""
app/services/kafka_service.py
──────────────────────────────────────────────────────────────────
Kafka Producer for publishing immutable ledger events.
(Mocked for local development until Docker/Kafka is running)
"""
import json

class KafkaService:
    @staticmethod
    async def publish_ledger_event(topic: str, payload: dict):
        """
        Publishes a transaction to the Kafka ledger.
        In a real app, this would use aiokafka.AIOKafkaProducer.
        """
        event_json = json.dumps(payload, default=str)
        print(f"[KAFKA] Published to '{topic}': {event_json}")
        
        # TODO: Implement actual Kafka producer
        # producer = AIOKafkaProducer(bootstrap_servers='localhost:9092')
        # await producer.start()
        # try:
        #     await producer.send_and_wait(topic, event_json.encode('utf-8'))
        # finally:
        #     await producer.stop()
