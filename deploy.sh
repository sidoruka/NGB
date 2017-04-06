echo "Starting deployment"

# Get current version
NGB_VERSION=$(./gradlew :printVersion |  grep "Project version is " | sed 's/^.*is //')
echo "Current version is ${NGB_VERSION}"

# DockerHub
echo "Deploying to DockerHub"
CORE_REL=${DOCKERHUB_REPO}:${NGB_VERSION}-release
CORE_LATEST=${DOCKERHUB_REPO}:latest

DEMO_REL=${CORE_REL}-demo
DEMO_LATEST=${CORE_LATEST}-demo

docker tag ngb:latest ${CORE_REL}
docker tag ngb:latest ${CORE_LATEST}

docker login -p ${DOCKERHUB_PASS} -u ${DOCKERHUB_LOGIN}

echo "Pushing ${CORE_REL}"
docker push ${CORE_REL}

echo "Pushing ${CORE_LATEST}"
docker push ${CORE_LATEST}

# Demo server - binaries
echo "Publishing binaries to a demo server"
DIST="dist"

JAR_ORIGIN="${DIST}/catgenome.jar"
WAR_ORIGIN="${DIST}/catgenome.war"
DOCS_ORIGIN="${DIST}/ngb-docs.tgz"
CLI_ORIGIN="${DIST}/ngb-cli.tar.gz"

JAR_VERSION="${DIST}/catgenome-${NGB_VERSION}.jar"
WAR_VERSION="${DIST}/catgenome-${NGB_VERSION}.war"
DOCS_VERSION="${DIST}/ngb-docs-${NGB_VERSION}.tar.gz"
CLI_VERSION="${DIST}/ngb-cli-${NGB_VERSION}.tar.gz"

gzip dist/ngb-cli.tar
mv ${JAR_ORIGIN} ${JAR_VERSION}
mv ${WAR_ORIGIN} ${WAR_VERSION}
mv ${DOCS_ORIGIN} ${DOCS_VERSION}
mv ${CLI_ORIGIN} ${CLI_VERSION}

echo -e ${DEMO_KEY} > demo.pem
sudo chmod 600 demo.pem
sudo scp -o StrictHostKeyChecking=no -i demo.pem dist/* ${DEMO_USER}@${DEMO_SRV}:${DEMO_PATH}

# Demo server - docker
# TODO
