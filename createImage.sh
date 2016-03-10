sudo apt-get install python-glanceclient

glance image-list

nova list

nova image-create 4324ab39-f8d2-4c2a-94aa-10eb17f4cca3 cloudify-manager-server  # create snapshot

glance --os-image-api-version 2 image-download --file manager.qcow2 --progress 3c525aee-e9db-486c-ad3e-af476bc11d78

glance image-list


$ qemu-img convert -O qcow2 original-image.raw image-converted.qcow

$ qemu-img info image-converted.qcow

