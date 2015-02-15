FROM gliderlabs/alpine:3.1

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks
# Python 3*, and that's not OK.
ENV LANG C.UTF-8

# We want to make sure all of our dependencies are updated
RUN apk update && apk upgrade

# Install our dependencies for Python itself.
RUN set -x \
    && apk-install openssl

# Download, compile, and install Python
ENV PYTHON_VERSION 3.4.2
RUN set -x \
    && apk-install --virtual build-dependencies curl build-base openssl-dev \
    && mkdir -p /usr/src/python \
    && curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
    && tar -xJC /usr/src/python -f python.tar.xz \
    && rm python.tar.xz \
    && cd "/usr/src/python/Python-$PYTHON_VERSION" \
    && ./configure --enable-shared --without-ensurepip \
    && make -j$(nproc) \
    && make install \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && ln -s /usr/local/bin/python3 /usr/local/bin/python \
    && rm -rf /usr/src/python \
    && apk del build-dependencies

# Download and install pip and setuptools
ENV X_PIP_VERSION 6.0.8
ENV SETUPTOOLS_VERSION 12.1
RUN set -x \
    && apk-install --virtual build-dependencies curl \
    && curl -SL "https://pypi.python.org/packages/py2.py3/p/pip/pip-$X_PIP_VERSION-py2.py3-none-any.whl" -o pip.whl \
    && PYTHONPATH=pip.whl python -m pip install "pip==$X_PIP_VERSION" \
    && rm pip.whl* \
    && pip install "setuptools==$SETUPTOOLS_VERSION" \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && find /usr/local -type f -name '*.exe' -exec rm -rf '{}' + \
    && rm -rf ~/.cache/ \
    && apk del build-dependencies
