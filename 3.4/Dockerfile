FROM gliderlabs/alpine:3.1

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks
# Python 3*, and that's not OK.
ENV LANG C.UTF-8

# Install our dependencies for Python itself.
RUN set -x \
    && apk-install openssl

# Download, compile, and install Python
ENV PYTHON_VERSION 3.4.2
RUN set -x \
    && apk-install --virtual build-dependencies gnupg curl build-base openssl-dev \
    && gpg --keyserver keys.gnupg.net --recv-keys 97FC712E4C024BBEA48A61ED3A5CA953F73C700D \
    && mkdir -p /usr/src/python \
    && curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
    && curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \
    && gpg --verify python.tar.xz.asc \
    && tar -xJC /usr/src/python -f python.tar.xz \
    && rm python.tar.xz* \
    && cd "/usr/src/python/Python-$PYTHON_VERSION" \
    && ./configure --enable-shared --without-ensurepip \
    && make -j$(nproc) \
    && make install \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && ln -s /usr/local/bin/python3 /usr/local/bin/python \
    && rm -rf ~/.gnupg/ \
    && rm -rf /usr/src/python \
    && apk del build-dependencies

# Download and install pip and setuptools
ENV X_PIP_VERSION 6.0.8
ENV SETUPTOOLS_VERSION 12.1
RUN set -x \
    && apk-install --virtual build-dependencies gnupg curl \
    && gpg --keyserver keys.gnupg.net --recv-keys 7C6B7C5D5E2B6356A926F04F6E3CBCE93372DCFA \
    && curl -SL "https://pypi.python.org/packages/py2.py3/p/pip/pip-$X_PIP_VERSION-py2.py3-none-any.whl" -o pip.whl \
    && curl -SL "https://pypi.python.org/packages/py2.py3/p/pip/pip-$X_PIP_VERSION-py2.py3-none-any.whl.asc" -o pip.whl.asc \
    && gpg --verify pip.whl.asc \
    && PYTHONPATH=pip.whl python -m pip install "pip==$X_PIP_VERSION" \
    && rm pip.whl* \
    && pip install "setuptools==$SETUPTOOLS_VERSION" \
    && rm -rf ~/.gnupg/ \
    && rm -rf ~/.cache/ \
    && apk del build-dependencies
