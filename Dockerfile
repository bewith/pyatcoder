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


# ユーザーIDをセット
ARG UID=1000
# グループIDをセット
ARG GID=1000
# コンテナ内に名称dockerでグループを作成
RUN groupadd -g ${GID} ubuntu
# コンテナ内に名称dockerでdockerグループに所属するユーザーを作成
RUN useradd -u ${UID} -g ${GID} -s /bin/bash -m ubuntu
# コンテナを実行するユーザーを指定
USER ${UID}
