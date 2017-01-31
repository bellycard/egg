FROM ruby:2.3

# Update packages to get imagemagick files up to date.
# Install OpenSSH Server (for Rubymine remote ruby sdk)
# Then remove /var/lib/apt/lists/* to save space for this layer.
RUN apt-get update -qq \
    && apt-get upgrade -qqy \
    && apt-get -qqy install openssh-server \
    rsync \
    && mkdir -p /var/run/sshd \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's|PermitRootLogin without-password|PermitRootLogin yes|g' /etc/ssh/sshd_config
RUN echo "root:sshroot" | chpasswd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=4 \
    BUNDLE_WITHOUT=production:staging

RUN bundle install

# Copy the env into the bashrc, so it is preserved for ssh logins
RUN env | awk '{print "export " $1}' >> ~/.bashrc

ADD . $APP_HOME