# Get current version
NGB_VERSION=$(./gradlew :printVersion |  grep "Project version is " | sed 's/^.*is //')

# Deploy to dockerhub
CORE_REL=${DOCKERHUB_REPO}:${NGB_VERSION}-release
CORE_LATEST=${DOCKERHUB_REPO}:latest

DEMO_REL=${CORE_REL}-demo
DEMO_LATEST=${CORE_LATEST}-demo

docker tag ngb:latest ${CORE_REL}
docker tag ngb:latest ${CORE_LATEST}

docker login -e ${DOCKERHUB_EMAIL} -p ${DOCKERHUB_PASS} -u ${DOCKERHUB_LOGIN}

docker push ${CORE_REL}
docker push ${CORE_LATEST}
