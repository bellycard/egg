FROM ruby:<%= ruby_version %>

# Update packages
RUN apt-get update -qq && apt-get upgrade -qqy
<% if ssh_support %>
RUN apt-get -qqy install openssh-server rsync
RUN mkdir -p /var/run/sshd
RUN sed -i 's|PermitRootLogin without-password|PermitRootLogin yes|g' /etc/ssh/sshd_config
RUN echo "root:sshroot" | chpasswd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
<% end %>

<% if supervisor %>
RUN apt-get -qqy install supervisor
RUN mkdir -p /var/log/supervisor
<% end %>

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=4 \
    BUNDLE_WITHOUT=production:staging

RUN bundle install

<% if supervisor %>
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
<% end %>

<% if ssh_support %>
# Copy the env into the bashrc, so it is preserved for ssh logins
RUN env | awk '{print "export " $1}' >> ~/.bashrc
<% end %>

ADD . $APP_HOME

<% if supervisor %>
CMD ["/usr/bin/supervisord"]
<% end %>