# Get current version
NGB_VERSION=$(./gradlew :printVersion |  grep "Project version is " | sed 's/^.*is //')

# Deploy to dockerhub
CORE_REL=${DOCKERHUB_REPO}:${NGB_VERSION}-release
CORE_LATEST=${DOCKERHUB_REPO}:latest

DEMO_REL=${CORE_REL}-demo
DEMO_LATEST=${CORE_LATEST}-demo

docker tag ngb:latest ${CORE_REL}
docker tag ngb:latest ${CORE_LATEST}

docker login -p ${DOCKERHUB_PASS} -u ${DOCKERHUB_LOGIN}

echo Pushing ${CORE_REL} to Dockerhub
docker push ${CORE_REL}

echo Pushing ${CORE_LATEST} to Dockerhub
docker push ${CORE_LATEST}

# Publish binaries to demo server
mv dist/catgenome.jar dist/catgenome-${NGB_VERSION}.jar
mv dist/catgenome.war dist/catgenome-${NGB_VERSION}.war
mv dist/catgenome.jar dist/catgenome-${NGB_VERSION}.jar
mv dist/ngb-docs.tgz dist/ngb-docs-${NGB_VERSION}.tar.gz
mv dist/ngb-cli.tar dist/ngb-cli-${NGB_VERSION}.tar
gzip dist/ngb-cli-${NGB_VERSION}.tar
