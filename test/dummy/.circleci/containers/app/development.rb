export DOCKERHUB_PASS="set me"
export DOCKERHUB_EMAIL="set me"
export DOCKERHUB_USER="set me"
export PUSH_DEPLOY_TAG=${CIRCLE_PREVIOUS_BUILD_NUM}_${CIRCLE_SHA1:0:7}
export DEPLOY_TAG=${CIRCLE_BUILD_NUM}_${CIRCLE_SHA1:0:7}
export DEPLOY_PATH="name of our app"
export SERVER_HOST="server ip address"
export SERVER_USER="probably root"
export SERVER_PORT="probably 22"
