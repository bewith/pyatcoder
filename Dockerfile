# 1. PyPyイメージの取得
FROM pypy:3.7

# 2. pyenvとpython3.9のインストール
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    . ~/.bashrc  && \
    pyenv install 3.9.1

# 3. ワークディレクトリを/srcに指定
WORKDIR /src

# 4. python仮想環境構築
COPY src/Pipfile* ./
RUN pip install pipenv && \
    pipenv install

# 5. pypy環境構築
COPY src/requirements.txt .
RUN pip install -r requirements.txt

# 6. atcodertoolsでsubmitできない不具合のパッチ適用
# https://github.com/kyuridenamida/atcoder-tools/pull/208
COPY src/language.py /opt/pypy/site-packages/atcodertools/common/

# 7. ubuntuユーザー/グループの作成
# https://wonwon-eater.com/docker-non-root/
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} ubuntu
RUN useradd -u ${UID} -g ${GID} -s /bin/bash -m ubuntu
