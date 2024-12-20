
# FROM python:3.11.2-bullseye
# ENV PIP_NO_CACHE_DIR off
# ENV PIP_DISABLE_PIP_VERSION_CHECK on
# ENV PYTHONUNBUFFERED 1
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV COLUMNS 80
# RUN apt-get update \
#  && apt-get install -y --force-yes \
#  nano python3-pip gettext chrpath libssl-dev libxft-dev \
#  libfreetype6 libfreetype6-dev  libfontconfig1 libfontconfig1-dev\
#   && rm -rf /var/lib/apt/lists/*
# WORKDIR /app/
# COPY requirements.txt /app/
# COPY daily_scraping_module.py /app/
# COPY daily_scraping_fetch_and_parse.py /app/
# RUN pip install -r requirements.txt

FROM python:3.11.2-bullseye

# Environment Variables
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV COLUMNS 80

# Install dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nano python3-pip gettext chrpath libssl-dev libxft-dev \
    libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev \
 && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app/

# Copy project files
COPY requirements.txt /app/
COPY daily_scraping_module.py /app/
COPY daily_scraping_fetch_and_parse.py /app/
COPY .env /app/  # Ensure .env is included if required locally for testing
COPY my_django_project/ /app/my_django_project/  # Add your Django project files

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Collect static files (Django-specific)
RUN python /app/my_django_project/manage.py collectstatic --noinput

# Expose the port Django or your application uses
EXPOSE 8000

# Run the application (adjust as needed)
CMD ["python", "/app/my_django_project/manage.py", "runserver", "0.0.0.0:8000"]
