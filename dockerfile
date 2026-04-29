# fase_1
FROM python:3.11-slim as builder

WORKDIR /app

RUN pip install --upgrade pip

COPY requirements.txt .

RUN pip install -r requirements.txt



# fase_2
FROM python:3.11-slim

WORKDIR /app

# criar novo user (pra n usar o root do linucis)
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# copia da máquina na fase_1 e coloca nessa atual(fase_2)
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

# copia a /app do projeto para a /app desse container
COPY app/ ./app/

# usa o usuario q oi criado
USER appuser
EXPOSE 8080
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]