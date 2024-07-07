# Use the official Python image as a base image
FROM python:3.10.14-bullseye
# Use the official Python image as a base image
# Set environment variables
ENV NODE_VERSION=18
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies, FFmpeg, and GEOS
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    python3-dev \
    gcc \
    libssl-dev \
    libsasl2-dev \
    libldap2-dev \
    libpq-dev \
    sudo \
    ffmpeg \
    libavcodec-dev \
    libavformat-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavutil-dev \
    libswscale-dev \
    libswresample-dev \
    libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs

# Install Yarn
RUN npm install --global yarn

# Create a non-root user and set up sudo
RUN useradd -m cvat && echo "cvat ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER cvat
WORKDIR /home/cvat

# Clone CVAT repository
RUN git clone https://github.com/opencv/cvat.git
WORKDIR /home/cvat/cvat/cvat

# Start Python venv
WORKDIR /home/cvat
RUN python3 -m venv venv
# RUN source venv/bin/activate
ENV PATH="/home/cvat/venv/bin:$PATH"

# Install CVAT Python dependencies
WORKDIR /home/cvat/cvat/cvat
RUN pip install --no-cache-dir -r requirements/base.txt

# Install Django Extensions for manage.py 
RUN pip install --no-cache-dir django-extensions django-silk

# Install uvicorn and gunicorn to run asgi.py
RUN pip install --no-cache-dir uvicorn gunicorn

# Debug step to verify Django installation
RUN python3 -m django --version

# Install CVAT UI dependencies
WORKDIR /home/cvat/cvat/cvat-ui
RUN yarn install --frozen-lockfile
RUN yarn build


# Build the CVAT server
WORKDIR /home/cvat/cvat
RUN python3 manage.py collectstatic --noinput

# Set up environment variables for Django
ENV DJANGO_SETTINGS_MODULE=cvat.settings.development
ENV DJANGO_ALLOWED_HOSTS=*
ENV DJANGO_SECRET_KEY=your_secret_key
ENV POSTGRES_USER=cvat
ENV POSTGRES_PASSWORD=cvat
ENV POSTGRES_DB=cvat
ENV POSTGRES_HOST=db
ENV POSTGRES_PORT=5432

# Set up environment variables for gunicorn
# ENV PATH=$PATH:/home/cvat/.local/lib/python3.10/site-packages


# Expose the port the app runs on
EXPOSE 8000

# Command to run the server
# CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "4", "cvat.wsgi:application"]
# CMD ["uvicorn", "--port", "8080", "--workers", "4", "cvat.asgi:application"]
CMD ["python", "-m", "gunicorn", "cvat.asgi:application", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]


# remember to navigate to the correct folder cvat.asgi means cvat/asgi
# python -m gunicorn cvat.asgi:application --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:8080
# python -m gunicorn --bind 0.0.0.0:8080 --workers 4 cvat.wsgi:application