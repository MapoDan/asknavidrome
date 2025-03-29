FROM alpine:3.15.0 as build
LABEL maintainer="Ross Stewart <rosskouk@gmail.com>"
LABEL org.opencontainers.image.source https://github.com/MapoDan/asknavidrome-ita

RUN apk add python3 py3-pip git build-base python3-dev libffi-dev openssl-dev

WORKDIR /opt

RUN python3 -m venv env

RUN git clone https://github.com/MapoDan/asknavidrome-ita.git

WORKDIR /opt/asknavidrome-ita

RUN source ../env/bin/activate && pip --no-cache-dir install wheel && pip --no-cache-dir install -r skill/requirements-docker.txt


FROM alpine:3.15.0
LABEL maintainer="Ross Stewart <rosskouk@gmail.com>"

RUN apk add python3

COPY --from=build /opt/env /opt/env
COPY --from=build /opt/asknavidrome-ita/skill /opt/asknavidrome-ita/

WORKDIR /opt/asknavidrome-ita

# Activate Python Virtual Environment
ENV PATH="/opt/env/bin:$PATH"

EXPOSE 5000

ENTRYPOINT ["python3", "app.py"]
