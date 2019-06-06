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
aws ec2 describe-key-pairs --key-names ${AWS_KEY_NAME} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    STA=1
    echo "[ERROR] Key pair file has already been exists '${AWS_KEY_NAME}'"
    return ${STA} 2> /dev/null
    exit ${STA}
fi

#
FILE_KEYPAIR_PEM="${MY_PEM_FILE}"
if [ ! -e "${FILE_KEYPAIR_PEM}" ]; then
    STA=1
    echo "Failure :: can not found file : ${FILE_KEYPAIR_PEM}."
    return ${STA} 2> /dev/null
    exit ${STA}
fi
if [ -e "${AWS_PEM_FILE}" ]; then
    echo "[INFO] Found file : ${AWS_PEM_FILE}"
    diff "${FILE_KEYPAIR_PEM}" "${AWS_PEM_FILE}" > /dev/null
    if [ $? -eq 0 ]; then
        echo "[INFO] Use ${AWS_PEM_FILE}"
    else
        echo "[INFO] Make backup ${AWS_PEM_FILE} to ${AWS_PEM_FILE}.bak"
        mv "${AWS_PEM_FILE}" "${AWS_PEM_FILE}.bak"
        echo "[INFO] Copy ${FILE_KEYPAIR_PEM} to ${AWS_PEM_FILE}"
        cp "${FILE_KEYPAIR_PEM}" "${AWS_PEM_FILE}"
    fi
else
    echo "[INFO] Copy ${FILE_KEYPAIR_PEM} to ${AWS_PEM_FILE}"
    cp "${FILE_KEYPAIR_PEM}" "${AWS_PEM_FILE}"
fi

#
FILE_KEYPAIR_PUB="${MY_PUB_FILE}"
if [ ! -e "${FILE_KEYPAIR_PUB}" ]; then
    STA=1
    echo "Failure :: can not found file : ${FILE_KEYPAIR_PUB}."
    return ${STA} 2> /dev/null
    exit ${STA}
fi
if [ -e "${AWS_PUB_FILE}" ]; then
    echo "[INFO] Found file : ${AWS_PUB_FILE}"
    diff "${FILE_KEYPAIR_PUB}" "${AWS_PUB_FILE}" > /dev/null
    if [ $? -eq 0 ]; then
        echo "[INFO] Use ${AWS_PUB_FILE}"
    else
        echo "[INFO] Make backup ${AWS_PUB_FILE} to ${AWS_PUB_FILE}.bak"
        mv "${AWS_PUB_FILE}" "${AWS_PUB_FILE}.bak"
        echo "[INFO] Copy ${FILE_KEYPAIR_PUB} to ${AWS_PUB_FILE}"
        cp "${FILE_KEYPAIR_PUB}" "${AWS_PUB_FILE}"
    fi
else
    echo "[INFO] Copy ${FILE_KEYPAIR_PUB} to ${AWS_PUB_FILE}"
    cp "${FILE_KEYPAIR_PUB}" "${AWS_PUB_FILE}"
fi


#
echo "[INFO] Import key-pair : ${AWS_KEY_NAME} : ${AWS_PUB_FILE}"
aws ec2 import-key-pair --key-name "${AWS_KEY_NAME}" --public-key-material "file://${AWS_PUB_FILE}"

#
