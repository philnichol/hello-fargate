# multi stage docker build, while not required for this image, if requirements.txt
# ever requires additional build-time dependencies, it will reduce final image size
FROM python:3.7.7-alpine3.11 AS build-image

RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt ./

RUN pip install -r requirements.txt

# runtime image
FROM python:3.7.7-alpine3.11 AS runtime-image

COPY --from=build-image /opt/venv /opt/venv

# install curl for Fargate healthchecks
RUN apk add curl

# remove apk and pip to (slightly) reduce size and attack surface
RUN apk del py-pip \
    && rm -rf /usr/local/bin/pip \
    && rm -rf /home/root/.cache/pip \
    && rm -rf /sbin/apk \
    && rm -rf  /etc/apk \
    && rm -rf /lib/apk \
    && rm -rf /use/share/apk \
    && rm -rf /var/lib/apk

ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE 1
ENV FLASK_APP="application.py"

# create non-root user with minimum required permissions
RUN mkdir -p /app \
    && addgroup -S app \
    && adduser -S -D -H app -G app \
    && chmod -R 755 /app

EXPOSE 5000

WORKDIR /app

COPY . .

USER app

ENTRYPOINT [ "/opt/venv/bin/flask", "run", "--host", "0.0.0.0"]
