# docker_vbox

docker run --name vbox -e vboxuser=foo -e vboxpass=bar -d --privileged=true -v /lib/modules:/lib/modules -v /data:/data s4ragent/vbox
