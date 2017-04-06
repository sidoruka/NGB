# Get current version
NGB_VERSION=$(./gradlew :printVersion |  grep "Project version is " | sed 's/^.*is //')

# Deploy to dockerhub
#CORE_REL=${DOCKERHUB_REPO}:${NGB_VERSION}-release
#CORE_LATEST=${DOCKERHUB_REPO}:latest

#DEMO_REL=${CORE_REL}-demo
#DEMO_LATEST=${CORE_LATEST}-demo

#docker tag ngb:latest ${CORE_REL}
#docker tag ngb:latest ${CORE_LATEST}

#docker login -p ${DOCKERHUB_PASS} -u ${DOCKERHUB_LOGIN}

#echo Pushing ${CORE_REL} to Dockerhub
#docker push ${CORE_REL}

#echo Pushing ${CORE_LATEST} to Dockerhub
#docker push ${CORE_LATEST}

# Publish binaries to demo server
JAR_ORIGIN='dist/catgenome.jar'
WAR_ORIGIN='dist/catgenome.war'
DOCS_ORIGIN='dist/ngb-docs.tgz'
CLI_ORIGIN='dist/ngb-cli.tar.gz'

JAR_VERSION='dist/catgenome-${NGB_VERSION}.jar'
WAR_VERSION='dist/catgenome-${NGB_VERSION}.war'
DOCS_VERSION='dist/ngb-docs-${NGB_VERSION}.tar.gz'
CLI_VERSION='dist/ngb-cli-${NGB_VERSION}.tar.gz'

gzip dist/ngb-cli.tar
mv ${JAR_ORIGIN} ${JAR_VERSION}
mv ${WAR_ORIGIN} ${WAR_VERSION}
mv ${DOCS_ORIGIN} ${DOCS_VERSION}
mv ${CLI_ORIGIN} ${CLI_VERSION}

echo -e ${DEMO_KEY} > demo.pem
sudo chmod 600 demo.pem
sudo scp -o StrictHostKeyChecking=no -i demo.pem dist/* ${DEMO_USER}@${DEMO_SRV}:${DEMO_PATH}
