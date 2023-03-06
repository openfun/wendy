# -- Base image --
FROM jupyter/base-notebook as base

# Upgrade pip to its latest release to speed up dependencies installation
RUN pip install --upgrade pip

COPY . /home/jovyan/work

WORKDIR /home/jovyan/work

RUN pip install -e .[dependencies]

# Un-privileged user running the application
USER ${DOCKER_USER:-1000}

# RUN pip install \
#     jupytext \
#     pandas \
#     scikit-learn \
#     nltk \
#     spacy \
#     seaborn

#RUN python -m spacy download fr_core_news_sm
