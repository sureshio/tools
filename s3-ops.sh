

#!/bin/bash

# folder to use to create current backup
BACKUP_WORKING_DIR=/tmp

# the folder that needs to be backup

S3_PATH=
ACTION='upload'

while getopts f:w:k:s:g:n:b:p:o:r:a:d:t: option
do
        case $option in
                f)
		            SOURCE_FILE=${OPTARG};
                    echo "UPLOAD_FILE:$SOURCE_FILE"
                    ;;
                t)
		            TARGET_FILE=${OPTARG};
                    echo "TARGET_FILE:$TARGET_FILE"
                    ;;
 	            n)
               	    NOTIFY_WEBHOOK=${OPTARG};
                    echo "NOTIFY_WEBHOOK:$NOTIFY_WEBHOOK"
                	;;                 
	            g)
               	    GPG_SECRET=${OPTARG};
                    echo "GPG_SECRET SET" 
                	;;
	            b)
               	    S3_BUCKET=${OPTARG};
                    echo "S3_BUCKET :$S3_BUCKET" 
                	;;
	            k)
               	    AWS_KEY=${OPTARG};
                    echo "AWS_SECRET: $AWS_KEY" 
                	;;
	            s)
               	    AWS_SECRET=${OPTARG};
                    echo "AWS_SECRET SET" 
                	;;
	            o)
               	    TARGET_FILE=${OPTARG};
                    echo "TARGET_FILE:$TARGET_FILE" 
                	;;
	            r)
               	    RESTORE_PATH=${OPTARG};
                    echo "RESTORE_PATH:$RESTORE_PATH" 
                	;;
	            a)
               	    ACTION=${OPTARG};
                    echo "ACTION:$ACTION" 
                	;;                
                \?) echo "Unknown option: -$OPTARG" ;;
        		*) echo "Unimplimented option: -$OPTARG";;
        esac
done


function notify {

    MSG="$1"

    if [ ! -z "${NOTIFY_WEBHOOK}" ]; then
        echo "Running Webhook ${NOTIFY_WEBHOOK}"
        HOSTNAME=`hostname`
        CURR_DATE=`date`
        CHAT_MSG="{\"username\":\"dataops\",    \"text\": \"${MSG}\"}"
        echo $CHAT_MSG
        curl -d "$CHAT_MSG" -H "Content-Type: application/json" -X POST ${NOTIFY_WEBHOOK}
    fi  
}

function upload {

    #encrypt data file
    if [ -f "${SOURCE_FILE}" ] &&  [ ! -z "${GPG_SECRET}" ]; then
        echo encypting file with gpg
        gpg --yes --batch --passphrase=$GPG_SECRET -c $SOURCE_FILE 
        SOURCE_FILE=${SOURCE_FILE}.gpg
    fi

    SOURCE_FILE_NAME=`basename $SOURCE_FILE`

   if [ -f "${SOURCE_FILE}" ] && [ ! -z "${S3_BUCKET}" ] && [ ! -z "${AWS_KEY}" ] && [ ! -z "${AWS_SECRET}" ]; then
        TARGET_FILE=${TARGET_FILE:-$SOURCE_FILE_NAME}
        echo "Uploading File to S3 /${S3_BUCKET}/${SOURCE_FILE_NAME}"
        resource="/${S3_BUCKET}/${SOURCE_FILE_NAME}"
        contentType="application/x-compressed-tar"
        dateValue=`date -R`
        stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
        signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${AWS_SECRET} -binary | base64`
        echo signature:$signature
        
        curl -X PUT -T "${SOURCE_FILE}" \
            -H "Host: ${S3_BUCKET}.s3.amazonaws.com" \
            -H "Date: ${dateValue}" \
            -H "Content-Type: ${contentType}" \
            -H "Authorization: AWS ${AWS_KEY}:${signature}" \
            https://${S3_BUCKET}.s3.amazonaws.com/${TARGET_FILE}
    fi
}

function download {

    #check if the restore path is empty
    if [ ! -z "${RESTORE_PATH}" ] && [ "$(ls -A $RESTORE_PATH)" ] && [ -z "${RESTORE_OVERWRITE}" ]; then
        echo "Restore folder $RESTORE_PATH is not Empty. Delete folder contents before restoring"
        exit 0;
    fi

    SOURCE_FILE_NAME=`basename $SOURCE_FILE`
    TARGET_FILE=${TARGET_FILE:-/tmp/$SOURCE_FILE_NAME}
   if  [ ! -z "${S3_BUCKET}" ] && [ ! -z "${AWS_KEY}" ] && [ ! -z "${AWS_SECRET}" ]; then
        echo "downloading File from s3 /${S3_BUCKET}/${SOURCE_FILE}"
        resource="/${S3_BUCKET}/${SOURCE_FILE}"
        contentType="application/x-compressed-tar"
        dateValue=`date -R`
        stringToSign="GET\n\n${contentType}\n${dateValue}\n${resource}"
        signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${AWS_SECRET} -binary | base64`
        echo signature:$signature
        
        curl -X GET  \
            -H "Host: ${S3_BUCKET}.s3.amazonaws.com" \
            -H "Date: ${dateValue}" \
            -H "Content-Type: ${contentType}" \
            -H "Authorization: AWS ${AWS_KEY}:${signature}" \
            https://${S3_BUCKET}.s3.amazonaws.com/${SOURCE_FILE} -o $TARGET_FILE
    fi

    if [ -f "${TARGET_FILE}" ] &&  [ ! -z "${GPG_SECRET}" ]; then
        PGP_OUTFILE="${TARGET_FILE%.gpg}"
        echo "decrypting file with gpg: gpg --yes --batch --passphrase=$GPG_SECRET  -o "${PGP_OUTFILE}" $TARGET_FILE"
        gpg --yes --batch --passphrase=$GPG_SECRET  -o "${PGP_OUTFILE}" $TARGET_FILE
        echo "decrypt completed outfile: ${PGP_OUTFILE}"
        echo "Deleting Downloaded file: TARGET_FILE"
        rm $TARGET_FILE
        TARGET_FILE="${PGP_OUTFILE}"
    fi

    if [ -f "${TARGET_FILE}" ] &&  [ ! -z "${RESTORE_PATH}" ]; then

        [ -d $RESTORE_PATH ] || mkdir -p $RESTORE_PATH
        echo restoring archive $TARGET_FILE to folder $RESTORE_PATH
        tar -xpzf $TARGET_FILE -C $RESTORE_PATH
        echo Deleting TARGET_FILE:$TARGET_FILE
        rm $TARGET_FILE
    fi
}


    if [[ "$ACTION" == 'download' ]] ; then
        download $skip
    elif [[ "$ACTION" == 'upload' ]] ; then
        upload $skip
    else
        usage_error "unrecognized command \"$action\""
    fi
