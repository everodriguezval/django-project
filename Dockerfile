# image what will provide the OS we're going to use
FROM python:3.9-alpine3.13

# meta tag
LABEL maintainer = 'eve.rodriguezval@gmail.com'

# display everything on the terminal (good to spot bugs)
ENV PYTHONUNBUFFERED 1

# to copy ./requirements.txt into /tmp/requirements.text inside docker container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app

WORKDIR /app

# expose a port
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
    build-base postgresql-dev musl-dev && \ 
    /py/bin/pip install -r /tmp/requirements.txt && \
    apk del .tmp-build-deps && \
    adduser --disabled-password django-user

# specify a path variable where we're going to install our packages
ENV PATH='/py/bin:$PATH'

USER django-user

