echo "--------------------------------------------------------------------------"
echo "Getting project, branch and commit names"
PROJECT=`git config --local remote.origin.url|sed -n 's#.*/\([^.]*\)\.git#\1#p'`
COMMIT=`git log -n 1 --pretty=format:'%h'`
if [ ! -z "$BRANCH_NAME" ] # ! For multibranch pipelines jobs
then
    BRANCH_TAG=$BRANCH_NAME
    DOCKER_TAG=${BRANCH_TAG}-${COMMIT}
    if [ $BRANCH_NAME == "main" ]
    then
        ENV_K8s=$BRANCH_NAME
    fi
else
    DOCKER_TAG=${BRANCH_TAG}
fi

echo branch name = $BRANCH_NAME
echo branch/tag=$BRANCH_TAG
BOOTSTRAPPER_REPO_URL=git@github.com:withmehealth/bootstrapper-init.git
ENV_K8s=${ENV_K8s:-$BRANCH_TAG}
AWS_SHARED_ECR_ACCOUNT=${AWS_SHARED_ECR_ACCOUNT:-033069444749}

echo project=${PROJECT} branch/tag=${BRANCH_TAG} commit=${COMMIT} env=${ENV_K8s}


echo --------------------------------------------------------------------------
echo "Change environment specific (put project, branch and commit in index.html)"
echo project=${PROJECT} branch/tag=${BRANCH_TAG} commit=${COMMIT} > index.html

echo
echo "--------------------------------------------------------------------------"
echo

{ # * Image already exists
    aws ecr describe-images --registry-id ${AWS_SHARED_ECR_ACCOUNT} --repository-name ${PROJECT} --image-ids imageTag=${DOCKER_TAG} --region us-east-1 > /dev/null 2> /dev/null &&
    echo "Image already exists"

} || { # * Image does not exist and needs to be built and pushed
    echo "Building Dockerfile"
    DOCKER_IMAGE=${AWS_SHARED_ECR_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}:${DOCKER_TAG}
    echo Docker image is ${DOCKER_IMAGE}
    docker build --network=host -t ${DOCKER_IMAGE} . || exit 1
    echo
    echo Pushing docker image
    docker push ${DOCKER_IMAGE}
    echo Done docker build and push
}


echo
echo --------------------------------------------------------------------------
echo Done
