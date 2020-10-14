# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install pip requirements
ADD requirements.txt .
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		libcurl4-openssl-dev \
		libssl-dev \
		procps \
        apt-file \
        python3-dev \
        build-essential \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds


RUN python -m pip install -r requirements.txt

WORKDIR /app
ADD . /app

# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
RUN useradd appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
ENTRYPOINT [ "python", "cryptonice/__main__.py"]


