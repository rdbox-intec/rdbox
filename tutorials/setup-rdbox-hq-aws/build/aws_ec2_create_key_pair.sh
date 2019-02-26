#!/bin/bash

. ${HOME}/.bashrc.rdbox-hq-aws

echo "aws configure"
aws configure
aws ec2 describe-account-attributes > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "SUCCESS :: login aws ec2"
else
    STA=$?
    echo "Failure :: can not login aws ec2. CODE=${STA}"
    return ${STA} 2> /dev/null
    exit ${STA}
fi

#
function create_key_pair () {
    echo '' > ${AWS_PEM_FILE}
    chmod 600 ${AWS_PEM_FILE}
    aws ec2 create-key-pair --key-name ${AWS_KEY_NAME} --query "KeyMaterial" --output text > ${AWS_PEM_FILE}
    if [ $? -ne 0 ] ; then
        echo "[ERROR] Cannot create key-pair : ${AWS_PEM_FILE}"
    else
        openssl rsa -inform pem -outform pem -in ${AWS_PEM_FILE} -pubout > ${AWS_PUB_FILE}
    fi
}
function delete_key_pair () {
    if [ -e "${AWS_PEM_FILE}" ] ; then
        rm ${AWS_PEM_FILE}
    fi
    aws ec2 delete-key-pair --key-name ${AWS_KEY_NAME}
}
function recreate_key_pair () {
    delete_key_pair
    create_key_pair
}

#
aws ec2 describe-key-pairs --key-names ${AWS_KEY_NAME} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[INFO] Found key-pair : ${AWS_KEY_NAME}"
    echo "[INFO] Checking... ${AWS_PEM_FILE}"
    if [ -e "${AWS_PEM_FILE}" ]; then
        openssl rsa -in "${AWS_PEM_FILE}" -text >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "[INFO] Recreate key-pair : ${AWS_KEY_NAME}"
            recreate_key_pair
        else
            echo "[INFO] Reuse key-pair : ${AWS_KEY_NAME}"
        fi
    else
        echo "[INFO] Recreate key-pair : ${AWS_KEY_NAME}"
        recreate_key_pair
    fi
else
    echo "[INFO] Not found key-pair : ${AWS_KEY_NAME}"
    echo "[INFO] Create key-pair : ${AWS_KEY_NAME}"
    create_key_pair
fi

#
