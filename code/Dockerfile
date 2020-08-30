# multi stage docker build, while not required for this image, if requirements.txt
# ever requires additional build-time dependencies, it will reduce final image size
FROM python:3.7.7-alpine3.11 AS build-image

LABEL maintainer=philnichol

# this is where the Makefile looks for the image tag
# version consists of: <PYTHON_VERSION>.<ALPINE_VERSION>.<APP_VERSION>
LABEL IMAGE_VERSION=377.311.2

RUN python3 -m venv /opt/venv

RUN apk add gcc musl-dev

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt ./

RUN pip install -r requirements.txt

# runtime image
FROM python:3.7.7-alpine3.11 AS runtime-image

# copy over the installed libs
COPY --from=build-image /opt/venv /opt/venv

# install curl for Fargate healthchecks
# remove apk and pip to (slightly) reduce size and attack surface
# create non-root user and give it rx access to /app
RUN apk add --no-cache curl \
    && apk del --no-cache py-pip \
    && rm -rf /usr/local/bin/pip \
    && rm -rf /home/root/.cache/pip \
    && rm -rf /sbin/apk \
    && rm -rf  /etc/apk \
    && rm -rf /lib/apk \
    && rm -rf /use/share/apk \
    && rm -rf /var/lib/apk \
    && mkdir -p /app \
    && addgroup -S app \
    && adduser -S -D -H app -G app \
    && chmod -R 755 /app

EXPOSE 5000

ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE 1
ENV FLASK_APP="application.py"

WORKDIR /app

COPY . .

USER app

ENTRYPOINT [ "/opt/venv/bin/flask", "run", "--host", "0.0.0.0"]
