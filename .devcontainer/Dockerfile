FROM mcr.microsoft.com/devcontainers/java:1-21-bookworm

# Remove stale Yarn apt source that can fail apt-get update during feature install.
RUN rm -f /etc/apt/sources.list.d/yarn.list