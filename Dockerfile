FROM python:3.12-slim

ARG TERRAFORM_VERSION=1.8.0

# gitやAWS CLIインストールに必要なものをインストール
RUN apt-get update && apt-get install -y git vim locales-all curl unzip bash jq groff less

# AWS CLIバージョン2のインストール
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws

# Terraformのインストール
RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# gitの日本語化設定
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
