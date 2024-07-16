FROM python:3.10-slim

RUN set -x \
  && apt update \
  && apt upgrade -y \
  && apt install -y \
  make

COPY . ./

RUN pip install \
  poetry 

RUN make deps

EXPOSE 5000

ENTRYPOINT [ "make", "run" ]
