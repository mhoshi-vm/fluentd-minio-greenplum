helm install minio oci://registry-1.docker.io/bitnamicharts/minio -n minio
helm upgrade minio oci://registry-1.docker.io/bitnamicharts/minio -n minio --set service.type=LoadBalancer
