nova --debug boot --image 3d8edfea-f1ba-44cc-93f2-5339ca875d9a --flavor 5 \
  --nic net-id=789ee6e1-0174-4db1-9109-b1e7001bdfbc \
  --nic net-id=e4df36c7-480a-40a1-a203-ff733c92f775 \
  --nic net-id=8519bba4-0288-442a-ab3c-6cb9df471e91 \
  alonVM

nova --debug boot --flavor 4 --image 3d8edfea-f1ba-44cc-93f2-5339ca875d9a \
  --nic net-id=789ee6e1-0174-4db1-9109-b1e7001bdfbc \
  --nic port-id=8f73821b-fe16-4b31-8643-10b28878d7a7 \
  --nic port-id=8f73821b-fe16-4b31-8643-10b28878d7a7 \
  testVM

