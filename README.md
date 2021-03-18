# ft_server
This is a docker image for wordpress based on debian buster.
Commands are:
docker build -t tag .
docker run [--name container_name] [-p 80:80] [-p 443:443] [-e AI=on] tag
