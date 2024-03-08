FROM python:3.12 as kopf_base_image
RUN pip install kopf
RUN addgroup --gid 1111 nonroot
RUN adduser --uid 1111 --gid 1111 --gecos "" --disabled-password nonroot
USER nonroot

FROM kopf_base_image
WORKDIR /hello-world-operator
COPY --chown=nonroot:nonroot main.py /hello-world-operator

CMD kopf run -A /hello-world-operator/main.py