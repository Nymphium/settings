FROM multiarch/ubuntu-core:arm64-xenial

RUN apt update
RUN apt install zsh git curl -y

WORKDIR /home
VOLUME /home

CMD [ "./setup.sh" ]
