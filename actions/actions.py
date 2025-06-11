# actions/actions.py

from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher

# 💥 LangChain SQL Bot import
from actions.langchain_sql_bot import process_query

class ActionChatbotQuery(Action):

    def name(self) -> Text:
        return "action_chatbot_query"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        user_input = tracker.latest_message.get('text')
        response_text = process_query(user_input)

        dispatcher.utter_message(text=response_text)
        return []
