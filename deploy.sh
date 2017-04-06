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

JAR_ORIGIN="catgenome.jar"
WAR_ORIGIN="catgenome.war"
DOCS_ORIGIN="ngb-docs.tgz"
CLI_ORIGIN="ngb-cli.tar.gz"

JAR_VERSION="catgenome-${NGB_VERSION}.jar"
WAR_VERSION="catgenome-${NGB_VERSION}.war"
DOCS_VERSION="ngb-docs-${NGB_VERSION}.tar.gz"
CLI_VERSION="ngb-cli-${NGB_VERSION}.tar.gz"

JAR_LATEST="catgenome-latest.jar"
WAR_LATEST="catgenome-latest.war"
DOCS_LATEST="ngb-docs-latest.tgz"
CLI_LATEST="ngb-cli-latest.tar.gz"

gzip dist/ngb-cli.tar
mv ${DIST}/${JAR_ORIGIN} ${DIST}/${JAR_VERSION}
mv ${DIST}/${WAR_ORIGIN} ${DIST}/${WAR_VERSION}
mv ${DIST}/${DOCS_ORIGIN} ${DIST}/${DOCS_VERSION}
mv ${DIST}/${CLI_ORIGIN} ${DIST}/${CLI_VERSION}

echo -e ${DEMO_KEY} > demo.pem
sudo chmod 600 demo.pem
sudo rsync -rave "ssh -o StrictHostKeyChecking=no -i demo.pem" dist/* ${DEMO_USER}@${DEMO_SRV}:${DEMO_PATH}/${NGB_VERSION}
sudo ssh ${DEMO_USER}@${DEMO_SRV} -o StrictHostKeyChecking=no -i demo.pem \
"cd ${DEMO_PATH};" \
"rm -rf ${NGB_VERSION}/docs;" \
"mkdir ${NGB_VERSION}/docs;" \
"tar -zxf ${NGB_VERSION}/${DOCS_VERSION} -C ${NGB_VERSION}/docs;" \
"rm -rf latest;" \
"cp -rf ${NGB_VERSION} latest;" \
"cd latest;" \
"mv ${JAR_VERSION} ${JAR_LATEST};" \
"mv ${WAR_VERSION} ${WAR_LATEST};" \
"mv ${DOCS_VERSION} ${DOCS_LATEST};" \
"mv ${CLI_VERSION} ${CLI_LATEST}"

# Demo server - docker
#echo "Removing all running dockers and starting ${DEMO_REL}"
#sudo ssh ${DEMO_USER}@${DEMO_SRV} -o StrictHostKeyChecking=no -i demo.pem \ 
#"docker stop $(docker ps -a -q);" \
#"docker rm $(docker ps -a -q);" \
#"docker rmi $(docker images -q);" \
#"docker run -p 8080:8080 -d --name ngbdemo ${DEMO_REL}"
