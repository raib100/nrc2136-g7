# Seet base image
FROM python:3.10

# Set work directory
WORKDIR /usr/src/nrc2136

# install system dependencies
RUN apt-get update \
  && apt-get -y install netcat gcc \
  && apt-get clean
RUN apt-get install make

# Get the api files
COPY Makefile .
COPY app ./app
COPY requirements.txt ./

# Install the requirements
RUN pip install -r requirements.txt

# Install the requirements
RUN flask init-db

# Run the app
# RUN flask run
CMD ["make", "launch_docker_app"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]