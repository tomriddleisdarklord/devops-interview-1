FROM python:3.8

WORKDIR /app

COPY requirements.txt /app/requirements.txt

RUN pip install -r requirements.txt

COPY . /app


EXPOSE 5000

# RUN pytest /app/tests/

CMD ["python", "/app/main.py"]
