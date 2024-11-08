# Use the official Python 3.11 Alpine image as a base
FROM python:3.11-alpine

# Set environment variables for Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

# Install Docker and other necessary dependencies
RUN apk update && apk add --no-cache \
    docker \
    bash \
    curl \
    git \
    openjdk11 \
    py3-pip \
    && rm -rf /var/cache/apk/*

# Install Jenkins agent dependencies (like JNLP client)
RUN pip install jenkins-agent

# Install Astro CLI
RUN curl -sSL install.astronomer.io | bash -s -- v1.30.0 && \
    astro version

# Create a directory for Jenkins agent configuration
RUN mkdir -p /opt/jenkins/agent

# Copy the necessary Jenkins agent JAR file (this step assumes you've downloaded it beforehand)
# You can also download it dynamically in the entrypoint if needed
COPY agent.jar /opt/jenkins/agent/agent.jar

# Set the working directory
WORKDIR /opt/jenkins/agent

# Expose any required ports (if needed for Jenkins communication)
EXPOSE 8080 8081 22

# Start the Jenkins agent process via JNLP
ENTRYPOINT ["java", "-jar", "/opt/jenkins/agent/agent.jar"]

# Default command to keep the container alive if needed
CMD ["-jnlpUrl", "http://<jenkins-server>:8081/computer/<agent-name>/slave-agent.jnlp", "-secret", "<secret>"]
