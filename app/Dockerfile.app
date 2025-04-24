FROM python-base:1.0


WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

ENTRYPOINT ["python", "app.py"]
CMD ["--username=admin", "--password=admin123"]