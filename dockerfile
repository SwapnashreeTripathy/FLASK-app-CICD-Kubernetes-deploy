FROM python:3.13.0a4-bookworm AS build
WORKDIR /app
COPY . .
CMD ["python", "app.py"]
