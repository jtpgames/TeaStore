#!/bin/bash
push_flag='false'
registry='descartesresearch/'     # e.g. 'descartesresearch/'

print_usage() {
  printf "Usage: docker_build.sh [-p] [-r REGISTRY_NAME]\n"
}

while getopts 'pr:' flag; do
  case "${flag}" in
    p) push_flag='true' ;;
    r) registry="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

docker build -t "${registry}teastore-db" ../utilities/tools.descartes.teastore.database/
docker build -t "${registry}teastore-kieker-rabbitmq" ../utilities/tools.descartes.teastore.kieker.rabbitmq/
docker build -t "${registry}teastore-base" ../utilities/tools.descartes.teastore.dockerbase/
perl -i -pe's|.*FROM descartesresearch/|FROM '"${registry}"'|g' ../services/tools.descartes.teastore.*/Dockerfile
docker build -t "${registry}teastore-registry" ../services/tools.descartes.teastore.registry/
docker build -t "${registry}teastore-persistence" ../services/tools.descartes.teastore.persistence/
docker build -t "${registry}teastore-image" ../services/tools.descartes.teastore.image/
docker build -t "${registry}teastore-webui" ../services/tools.descartes.teastore.webui/
docker build -t "${registry}teastore-auth" ../services/tools.descartes.teastore.auth/
docker build -t "${registry}teastore-recommender" ../services/tools.descartes.teastore.recommender/
perl -i -pe's|.*FROM '"${registry}"'|FROM descartesresearch/|g' ../services/tools.descartes.teastore.*/Dockerfile

push_flag='false' # always false, because we use descartesresearch as the registry and do not want to overwrite anything from other people :)

if [ "$push_flag" = 'true' ]; then
  docker push "${registry}teastore-db"
  docker push "${registry}teastore-kieker-rabbitmq"
  docker push "${registry}teastore-base"
  docker push "${registry}teastore-registry"
  docker push "${registry}teastore-persistence"
  docker push "${registry}teastore-image"
  docker push "${registry}teastore-webui"
  docker push "${registry}teastore-auth"
  docker push "${registry}teastore-recommender"
fi
