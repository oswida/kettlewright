# Use an official Python runtime as the base image
FROM python:3.10

# Set environment variables to avoid Python buffering and enable Flask debugging
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Set up environment variables for the UID and GID
ARG UID
ARG GID

# Create a group and user with the same UID and GID as the host user
RUN groupadd --gid $GID kettlewright && \
    useradd --uid $UID --gid $GID --create-home --shell /bin/bash kettlewright

# Copy the requirements file and change ownership
COPY requirements.txt /app/
RUN chown kettlewright:kettlewright /app/requirements.txt

# Install the Python dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy the entire application code and set ownership
COPY . /app/
RUN chown -R kettlewright:kettlewright /app

# Set the correct file permissions
RUN chmod -R u+rw /app

# Switch to the non-root user
USER kettlewright

# Expose the port that the Flask app will run on
EXPOSE 8000

# Command to run the Flask application with Gunicorn and WebSocket support
CMD ["gunicorn", "--worker-class", "eventlet", "-w", "2", "-b", "0.0.0.0:8000", "app:application"]
