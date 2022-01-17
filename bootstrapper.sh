echo "--------------------------------------------------------------------------"
echo "Getting project, branch and commit names"
PROJECT='devops-interview-1'
COMMIT=`git log -n 1 --pretty=format:'%h'`


DOCKER_TAG=${BRANCH_TAG}-${COMMIT}

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
    docker tag ${DOCKER_IMAGE} ${AWS_SHARED_ECR_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}:latest
    echo
    echo Pushing docker image
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_SHARED_ECR_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com
    docker push ${DOCKER_IMAGE}
    docker push ${AWS_SHARED_ECR_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}:latest
    echo Done docker build and push
}

echo Deploy ---------------

kubectl -n ${ENV_K8s} apply -f kubernetes/

echo
echo --------------------------------------------------------------------------
echo Done
