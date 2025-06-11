# actions/langchain_sql_bot.py

# 네 기존 코드에서 필요한 부분만 import 하면 됨!

import configparser
from sqlalchemy import create_engine
#from langchain_community.utilities import SQLDatabase
from langchain.utilities import SQLDatabase  # ✅ langchain==0.0.300 에 존재함
#from langchain_experimental.sql import SQLDatabaseChain

# ? INI 파일 로드
gcConfigINI = r"C:\HIB70\HibConfig.ini"
gcpConfig = configparser.ConfigParser()
gcpConfig.read(gcConfigINI) 

# ? DB 설정 불러오기
gdicDbConnect = {
    'server': gcpConfig.get("DATABASE", "ServerName"),
    'user': gcpConfig.get("DATABASE", "DatabaseUser"),
    'password': gcpConfig.get("DATABASE", "DatabasePass"),
    'database': gcpConfig.get("DATABASE", "DatabaseName"),
    'driver' : '{ODBC Driver 17 for SQL Server}' # 드라이버는 사용자의 환경에 맞게 설정     
}

# 🧱 sqlalchemy URL 객체 생성 (권장 방식)
connection_string = (
    f"DRIVER={gdicDbConnect['driver']};"
    f"SERVER={gdicDbConnect['server']};"
    f"DATABASE={gdicDbConnect['database']};"
    f"UID={gdicDbConnect['user']};"
    f"PWD={gdicDbConnect['password']}"
)

from sqlalchemy.engine import URL
import urllib
connection_url = URL.create(
    "mssql+pyodbc",
    query={"odbc_connect": urllib.parse.quote_plus(connection_string)},
)
engine = create_engine(connection_url)
db = SQLDatabase.from_uri(
                        connection_url,                        
                        include_tables=["PB_PERSON"]
                        )

#from langchain_community .llms import LlamaCpp
from langchain .llms import LlamaCpp
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain
from langchain.memory import ConversationBufferMemory

# LlamaCpp 모델 구성
MODEL_PATH = "D:\\Python\\LLAMA\\mistral-7b-instruct-v0.1.Q5_K_M.gguf"

LClim = LlamaCpp(
    model_path=MODEL_PATH,
    n_ctx=4096,
    temperature=0.7,
    max_tokens=512
)

ptPrompt = PromptTemplate(
    input_variables=["history", "input"],
    template="""
    너는 대한민국 병원 EMR 시스템 사용자 지원 챗봇이야.
    병원 직원(의사, 간호사, 원무과 직원 등)이 EMR 프로그램 사용 중 궁금한 사항을 질문하면 친절하게 설명해 줘.
    반드시 한국어로 대답하고, 모르는 질문에는 "해당 내용은 현재 지원하지 않습니다. 관리자에게 문의해 주세요."라고 답변해.
    쿼리를 생성할 때는 MS SQL 문법을 따라서 만들어줘

    지금까지의 대화 기록:
    {history}

    사용자 질문: {input}

    챗봇 답변:
    """
)
# Memory 구성 (대화 흐름 유지)
cbmMemory = ConversationBufferMemory(memory_key="history")

# LLM Chain 구성 → 요게 바로 llm_chain!
llm_chain = LLMChain(llm=LClim, prompt=ptPrompt, memory=cbmMemory)

# SQLDatabaseChain 구성
sql_prompt = PromptTemplate(
    input_variables=["query"],
    template="""
    너는 MS SQL 전문가야. 아래 질문에 맞는 SQL 쿼리를 작성해.
    반드시 MS SQL 문법을 따르고, 불필요한 설명은 하지 말고 쿼리만 출력해.

    질문: {query}

    SQL 쿼리:
    """
)
#db_chain = SQLDatabaseChain.from_llm(LClim, db, verbose=True)
db_chain = LLMChain(llm=LClim, prompt=sql_prompt)

faq_data = [
    {"question": "마약처방전 어디에서 출력해?", "answer": "EMR 프로그램의 [처방전 출력] 메뉴에서 출력 가능합니다. 메뉴 위치: 상단 바 > 처방전 출력."},
    {"question": "퇴원요약서 출력은 어디서 해?", "answer": "EMR 프로그램 내 [진단서/증명서 발급] 메뉴에서 퇴원요약서 출력 가능."},
    {"question": "검사결과 어디서 조회해?", "answer": "EMR 프로그램의 [검사결과 조회] 메뉴에서 결과 확인 가능."}
]

# 통계 SQL 템플릿 경로
import pandas as pd
import json
import os

TEMPLATE_DIR = "query_templates"
MAPPING_FILE = os.path.join(TEMPLATE_DIR, "mapping.json")

# 템플릿 매핑 로드
with open(MAPPING_FILE, "r", encoding="utf-8") as f:
    QUERY_MAP = json.load(f)

def load_template(keyword: str) -> str:
    filename = QUERY_MAP.get(keyword)
    if not filename:
        return None
    path = os.path.join(TEMPLATE_DIR, filename)
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

from datetime import datetime
import dateparser
import re
    
# 2. 질문 분석 함수
def extract_params(question):
    date_text = re.search(r"(지난달|[0-9]{1,2}월|올해|작년)", question)
    dtype = "입원" if "입원" in question else "외래" if "외래" in question else "전체"
    standard = "처방" if "처방" in question else "진단" if "진단" in question else "전체"

    if date_text:
        dt = dateparser.parse(date_text.group())
        if dt:
            start = dt.replace(day=1)
            end = (start.replace(month=start.month % 12 + 1, day=1) - pd.Timedelta(days=1))
        else:
            start, end = datetime.now(), datetime.now()
    else:
        start, end = datetime.now(), datetime.now()

    return {
    "DATE": start.strftime('%Y-%m-%d'),
    "DATE_FROM": start.strftime('%Y-%m-%d'),
    "DATE_TO": end.strftime('%Y-%m-%d'),
    "TIME_FROM": start.strftime('%H:%M:%S'),
    "TIME_TO": end.strftime('%H:%M:%S'),
    "DATETIME_FROM": start.strftime('%Y-%m-%d %H:%M:%S'),
    "DATETIME_TO": end.strftime('%Y-%m-%d %H:%M:%S'),
    "TYPE": dtype,
    "STANDARD": standard
    }    
    
# FAISS
#from langchain_community.vectorstores import FAISS
#from langchain_community.document_loaders import TextLoader
from langchain.vectorstores import FAISS
from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter

#from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain.embeddings import HuggingFaceEmbeddings
#from langchain_core.documents import Document
#from langchain.docstore.document import Document  # langchain==0.0.300 에서는 이렇게 사용
from langchain.chains import RetrievalQA

INDEX_PATH = "menus_index"
TXT_FILE = "utf8HowToUseHIB.txt"

# 임베딩 모델 준비
embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

# 문서 변환
# docs = [Document(page_content=f"{item['question']}###{item['answer']}") for item in faq_data]

# FAISS index 생성
# faiss_index = FAISS.from_documents(docs, embeddings)

# index 저장 (원하면 나중에 로드 가능)
# faiss_index.save_local("faiss_index")

# 2. FAISS 인덱스 로드 or 생성
if os.path.exists(INDEX_PATH):
    print("📂 저장된 인덱스를 불러옵니다...")
    #vectordb = FAISS.load_local(INDEX_PATH, embeddings, allow_dangerous_deserialization=True)
    vectordb = FAISS.load_local(INDEX_PATH, embeddings)
else:
    print("📄 메뉴 문서로부터 인덱스를 새로 생성합니다...")
    loader = TextLoader(TXT_FILE, encoding="utf-8-sig")
    documents = loader.load()

    splitter = CharacterTextSplitter(chunk_size=200, chunk_overlap=20)
    docs = splitter.split_documents(documents)

    vectordb = FAISS.from_documents(docs, embeddings)
    vectordb.save_local(INDEX_PATH)
    print("✅ 인덱스 저장 완료!")

# 3. QA 체인 구성
retriever = vectordb.as_retriever(search_type="similarity", k=3)
faq_chain = RetrievalQA.from_chain_type(
    llm=LClim, 
    retriever=retriever
)

from sqlalchemy import text
from collections import defaultdict
from tenacity import retry, wait_random_exponential, stop_after_attempt, RetryError #TIME OUT 기능 추가

# 💡 재시도 래퍼 함수
@retry(
    wait=wait_random_exponential(min=1, max=10),  # 1~10초 사이 랜덤 대기
    stop=stop_after_attempt(3),                   # 최대 3번 시도
)
def safe_llm_call(llm, prompt):
    print("💬 LLM 호출:", prompt)
    return llm.invoke(prompt)

import csv
import os
from datetime import datetime

LOG_FILE = "chat_log.csv"

def append_chat_log(user_text: str, bot_text: str):
    """CSV 파일에 대화 로그 추가"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    file_exists = os.path.isfile(LOG_FILE)

    with open(LOG_FILE, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(["timestamp", "user", "bot"])
        writer.writerow([timestamp, user_text, bot_text])    
        
def get_generated_sql(intermediate):
    if not intermediate:
        return "-- 없음 --"
    # first = intermediate[0]
    # if isinstance(first, dict):
    #    return first.get("sql_cmd", "-- 없음 --")
    # elif isinstance(first, str):
    #     return first
    for step in intermediate:
        if isinstance(step, dict) and "sql_cmd" in step:
            return step["sql_cmd"]
        elif isinstance(step, str) and "SELECT" in step.upper():
            return step.strip()  # SQL문으로 추정되는 문자열 반환
    return "-- 없음 --"  

# FAQ 검색 함수
def search_faq(user_question):
    docs = vectordb.similarity_search(user_question, k=1)
    if docs:
        return docs[0].page_content.strip()
    return None

# Routing 함수
def route_query(query: str) -> str:
    if not query:
        return "unknown"
    if any(k in query for k in QUERY_MAP):
        return "template"
    elif any(x in query for x in ["통계", "건수", "수량", "영수", "차트", "대장", "분석", "보고서"]):
        return "langchain_sql"
    else:
        return "general"

# Rasa에서 호출할 통합 처리 함수
def process_query(user_input: str) -> str:
    print(f"[DEBUG] process_query() called with input: {user_input}")  # ✅ 요거 추가
    query_type = route_query(user_input)
    print(f"[DEBUG] route_query() 결과: {query_type}")                 # ✅ 요것도 추가해보자

    if query_type == "template":
        try:
            matched_key = next(k for k in QUERY_MAP if k in user_input)
            sql_template = load_template(matched_key)
            if sql_template:
                params = extract_params(user_input)
                sql = sql_template.format_map(defaultdict(str, params))
                with engine.connect() as conn:
                    result = conn.execute(text(sql))
                    rows = result.fetchall()
                    if not rows:
                        return "❗ 결과가 없습니다. 조건을 다시 확인해주세요."
                    else:
                        output = []
                        for row in rows:
                            output.append(str(row))
                        return "\n".join(output)
            else:
                return "❗ 템플릿을 찾을 수 없습니다."
        except Exception as e:
            return f"🚨 SQL 실행 오류: {str(e)}"

    elif query_type == "langchain_sql":
        try:
            #from langchain_core.runnables import Runnable
            #if isinstance(db_chain, Runnable):
            #    sql_response = db_chain.invoke({"query": user_input})
            #else:
            sql_response = db_chain.run(user_input)
                
            print("생성된 SQL 쿼리:", sql_response)

            # 그 다음 SQL 쿼리 실행 (SQLDatabase 사용)
            with engine.connect() as conn:
                result = conn.execute(text(sql_response))
                rows = result.fetchall()

                if not rows:
                    print("❗ 결과가 없습니다.")
                else:
                    for row in rows:
                        print(row)
            
            result_text = sql_response.get("result", "-- 결과 없음 --")
            return result_text
        except Exception as e:
            return f"🚨 LangChain SQL 오류: {str(e)}"

    elif query_type == "general":
        docs = vectordb.similarity_search(user_input, k=1)
        if docs:
            result = faq_chain.run(user_input)
            return result
        else:
            llm_result = llm_chain.run(input=user_input)
            return llm_result

    else:
        return "❓ 이해하지 못했어요. 다시 질문해 주세요."
