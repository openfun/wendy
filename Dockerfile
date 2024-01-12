# -- Base image --
FROM jupyter/minimal-notebook:latest as base

# Upgrade pip to its latest release to speed up dependencies installation
RUN pip install --upgrade pip

COPY . /home/jovyan/work

WORKDIR /home/jovyan/work

RUN pip install -e .[dependencies]

# -- Development image --
FROM base as development

RUN pip install -e .[dev]

# Un-privileged user running the application
USER ${DOCKER_USER:-1000}
