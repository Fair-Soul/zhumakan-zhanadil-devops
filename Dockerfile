# Base image: Python 3.12 on Debian (slim version is smaller)
FROM python:3.12-slim

LABEL maintainer="Zhanadil Zhumakan" \
      group="IT2-2304" \
      student_id="38093"

# print python output to docker logs immediately, without buffering
ENV PYTHONUNBUFFERED=1

# all next instructions and the app itself work inside /devops
WORKDIR /devops

# copy application code and configuration into the image
COPY app/ ./app/
COPY config/ ./config/
COPY Zhumakan_Zhanadil_info.txt ./

# check python syntax (build fails if the code is broken)
# and create a normal user, so the app does not run as root
RUN python -m py_compile app/app.py \
    && useradd --create-home appuser \
    && chown -R appuser:appuser /devops

USER appuser

# the web server inside the container listens on port 8000
EXPOSE 8000

CMD ["python", "app/app.py"]
