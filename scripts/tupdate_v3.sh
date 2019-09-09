#!/bin/bash

COLOR_NONE='\033[0m'
COLOR_BLACK='\033[0;30m'
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_BROWN='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_PURPLE='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_LIGHT_GRAY='\033[0;37m'
COLOR_DARK_GRAY='\033[1;30m'
COLOR_LIGHT_RED='\033[1;31m'
COLOR_LIGHT_GREEN='\033[1;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_LIGHT_PURPLE='\033[1;35m'
COLOR_LIGHT_CYAN='\033[1;36m'
COLOR_WHITE='\033[1;37m'

UPDATE_CONFIG="${HOME}/tos_update_config.sh"
JOB_NUMBER=7
DST_PASSWD=tmaxos123!
TOS_ERROR_FILE="/tmp/tos_update_error"
ERROR_NUM=0
architecture=`getconf LONG_BIT`
TOGATE_SERVER_PATH="togate@192.168.10.86"
TOGATE_INSTALL_PATH="/system/app"

forceNonSudo()
{
    if [ "$(id -u)" -eq "0" ]; then
        echo -e "Do not use sudo at this time."
        exit 0
    fi
}

#forceNonSudo

promptStartUpdate()
{
    read -p "위의 내용이 맞습니까? <y/n> : " prompt
    if [[ ${prompt} == "n" ]]; then
        exit 0;
    elif [[ ${prompt} != "y" ]]; then
        echo -e "Wrong input. Please enter y or n."
        promptStartUpdate
    fi
}

notice_updated()
{
    if [ ! -e /tmp/tos_update_error ]; then
        echo -e "\n${COLOR_GREEN}Opening update config file. Check installation info before proceeding.${COLOR_NONE}\n"
        read -p "Press any key to continue." prompt

        if [ ! -e ${UPDATE_CONFIG} ]; then
            sudo touch ${UPDATE_CONFIG}
            echo "WHOAMI=`whoami`" >> ${UPDATE_CONFIG}
            echo "TRUNK_PATH=/home/${WHOAMI}/trunk" >> ${UPDATE_CONFIG}
            echo "TOS_MODE=debug" >> ${UPDATE_CONFIG}
            echo "TOS_VERSION=v3.9.1" >> ${UPDATE_CONFIG}
            echo "TOS_UPDATER_ADDRESS=tos_updater@192.168.11.182" >> ${UPDATE_CONFIG}
            echo "TOGATE_SERVER_PATH=togate@192.168.10.86" >> ${UPDATE_CONFIG}
            echo "ZONE_ON=ON" >> ${UPDATE_CONFIG}
        else
            sudo chmod 755 ${UPDATE_CONFIG}
        fi

        vim ${UPDATE_CONFIG}
    fi

    source ${UPDATE_CONFIG}

    echo -e "\n${COLOR_GREEN}아래 정보대로 TOS를 업데이트할 것입니다. \n"

    echo "Trunk path : ${TRUNK_PATH}"
    echo "Build mode : ${TOS_MODE}" 
    echo "Zone on/off: ${ZONE_ON}"
    echo "TOS version : ${TOS_VERSION}"

    echo -e "\n정보를 확인해 주세요, 이상 있을 시 tos_update_config.sh를 수정해서 다시 넣어주세요."
    echo -e "에러가 발생하였을 경우, http://192.168.2.112:3000/issues/559 에 방문하여 tos_update_error_report 파일을 참조하세요.${COLOR_NONE}\n"

    promptStartUpdate
}

promptLastStart()
{
    echo -e "\n"
    read -p "Do you want to continue from last error? <y/n> : " prompt
    if [[ $prompt == "y" ]]; then
        return 0;
    elif [[ $prompt == "n" ]]; then 
        return 1;
    else
        echo -e "Wrong input. Enter y/n"
        promptLastStart
    fi
}

startFromLastError()
{
    ERROR_FILE=`ls "${TOS_ERROR_FILE}" 2> /dev/null`
    if [ "${ERROR_FILE}" == "" ]; then
        notice_updated
    elif ! promptLastStart; then
        sudo rm ${ERROR_FILE}
        notice_updated
    else
        source ${UPDATE_CONFIG}
        ERROR_NUM=`sudo cat ${ERROR_FILE}`
        echo -e "error number is ${ERROR_NUM}"
    fi
}

startFromLastError

TOGATE_VER=${TOS_VERSION:1}

sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
sudo ln -s /usr/bin/make /usr/bin/gmake
sudo apt-get -f -y install
sudo apt-get -f -y update
sudo apt-get -y autoremove

perror()
{
    echo -e "${COLOR_RED}$1 : $2${COLOR_NONE}"
    exit 1
}

CURRENT_STEP=1

if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then #1
    echo -e "${COLOR_GREEN}Fetching tos version ${TOS_VERSION}${COLOR_NONE}"
    cd ${TRUNK_PATH}
    already_fetched=`sudo git log ${TOS_VERSION}`
    if [ "${already_fetched}" == "" ]; then
        sudo git fetch

        already_fetched=`sudo git log ${TOS_VERSION}`
        if [ "${already_fetched}" == "" ]; then
            echo -e "${COLOR_RED}Failed git fetch. Exiting${COLOR_NONE}"
            exit 1
        fi
    fi
fi

sudo git checkout -f ${TOS_VERSION}

CURRENT_STEP=$((CURRENT_STEP + 1 )) #2
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    if [ -e /home/AllUsers/AppList/ToGate.tap ]; then
        echo -e "${COLOR_GREEN}Deleting Togate${COLOR_NONE}"
        sudo rm -rf /home/AllUsers/AppList/ToGate.tap
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #3
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    if [ -e /root/tos_build ]; then 
        echo -e "${COLOR_GREEN}Removing tos_build directory${COLOR_NONE}"
        echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
        sudo rm -rf ${HOME}/tos_build ${LINENO} "rm tos_build error" ${CURRENT_STEP}
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #4
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "${COLOR_GREEN}Checking config.cmake${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    cd ${TRUNK_PATH}/ || perror ${LINENO} "cd trunk error" ${CURRENT_STEP}

    # kwanghyun_jung 2019.09.09 : remove comments as necessary
#    if [ ${ZONE_ON} == "ON" ]; then
#        sudo sed -e "s/zone seperation version\" OFF/zone seperation version\" ON/g" ${TRUNK_PATH}/config.cmake.eg > ${TRUNK_PATH}/config.cmake || perror ${LINENO} "config.cmake error" ${CURRENT_STEP}
#    elif [ ${ZONE_ON} == "OFF" ]; then 
#        sudo sed -e "s/zone seperation version\" ON/zone seperation version\" OFF/g" ${TRUNK_PATH}/config.cmake.eg > ${TRUNK_PATH}/config.cmake || perror ${LINENO} "config.cmake error" ${CURRENT_STEP}
#    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #5
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    sudo rm -rf /system.bak
    sudo mv -i /system /system.bak
    sudo mkdir /system
    sudo rm -rf /windata /rsmdata /tos

    echo -e "${COLOR_GREEN}Installing linux system pkg${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    cd ${TRUNK_PATH}/pkg || perror ${LINENO} "cd trunk/pkg error" ${CURRENT_STEP}
    sudo apt-get update
    sudo ./install_linux_pkg.sh -a || perror ${LINENO} "./install_linux_pkg.sh error" ${CURRENT_STEP}
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #6
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    cd ${TRUNK_PATH}/ || perror ${LINENO} "cd trunk error" ${CURRENT_STEP}
    cd build
    if [ "${TOS_MODE}" == "release" ]
    then
        echo -e "${COLOR_GREEN}./init_release.sh${COLOR_NONE}"
        sudo ./init_release.sh || perror ${LINENO} "./init_release.sh error" ${CURRENT_STEP}
    else
        echo -e "${COLOR_GREEN}./init_debug.sh${COLOR_NONE}"
        sudo ./init_debug.sh || perror ${LINENO} "./init_debug.sh error" ${CURRENT_STEP}
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #7
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "${COLOR_GREEN}Building src/lib/tgk${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ "${TOS_MODE}" == "release" ] 
    then
        cd /root/tos_build/binary_release/src/lib/tgk || perror ${LINENO} "cd /root/tos_build/binary_release/src/lib/tgk error" ${CURRENT_STEP}
        sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_release/src/lib/tgk" ${CURRENT_STEP}
    else
        cd /root/tos_build/binary_debug/src/lib/tgk || perror ${LINENO} "cd /root/tos_build/binary_debug/src/lib/tgk error" ${CURRENT_STEP}
	sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_debug/src/lib/tgk" ${CURRENT_STEP}
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #8
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "${COLOR_GREEN}Building src/lib/desktop/shellapi${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ "${TOS_MODE}" == "release" ] 
    then
        cd /root/tos_build/binary_release/src/lib/desktop/shellapi || perror ${LINENO} "cd /root/tos_build/binary_release/src/lib/desktop/shellapi error" ${CURRENT_STEP}
        sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_release/src/lib/desktop/shellapi" ${CURRENT_STEP}
    else
        cd /root/tos_build/binary_debug/src/lib/desktop/shellapi || perror ${LINENO} "cd /root/tos_build/binary_debug/src/lib/desktop/shellapi error" ${CURRENT_STEP}
	sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_debug/src/lib/desktop/shellapi" ${CURRENT_STEP}
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #9
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "${COLOR_GREEN}Building src/core${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ "${TOS_MODE}" == "release" ] 
    then
        cd /root/tos_build/binary_release/src/core || perror ${LINENO} "cd /root/tos_build/binary_release/src/core error" ${CURRENT_STEP}
        sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_release/src/core" ${CURRENT_STEP}
    else
        cd /root/tos_build/binary_debug/src/core || perror ${LINENO} "cd /root/tos_build/binary_debug/src/core error" ${CURRENT_STEP}
	sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_debug/src/core" ${CURRENT_STEP}
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #10
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "${COLOR_GREEN}Building src/lib${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ "${TOS_MODE}" == "release" ] 
    then
        cd /root/tos_build/binary_release/src/lib || perror ${LINENO} "cd /root/tos_build/binary_release/src/lib error" ${CURRENT_STEP}
        sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_release/src/lib" ${CURRENT_STEP}
    else
        cd /root/tos_build/binary_debug/src/lib || perror ${LINENO} "cd /root/tos_build/binary_debug/src/lib error" ${CURRENT_STEP}
	sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_debug/src/lib" ${CURRENT_STEP}
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #11
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "${COLOR_GREEN}Building src/app${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ "${TOS_MODE}" == "release" ] 
    then
        cd /root/tos_build/binary_release/src/app || perror ${LINENO} "cd /root/tos_build/binary_release/src/app error" ${CURRENT_STEP}
        sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_release/src/app" ${CURRENT_STEP}
    else
        cd /root/tos_build/binary_debug/src/app || perror ${LINENO} "cd /root/tos_build/binary_debug/src/app error" ${CURRENT_STEP}
	sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_debug/src/app" ${CURRENT_STEP}
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #12
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "${COLOR_GREEN}Building src/bin${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ "${TOS_MODE}" == "release" ] 
    then
        cd /root/tos_build/binary_release/src/bin || perror ${LINENO} "cd /root/tos_build/binary_release/src/bin error" ${CURRENT_STEP}
        sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_release/src/bin" ${CURRENT_STEP}
    else
        cd /root/tos_build/binary_debug/src/bin || perror ${LINENO} "cd /root/tos_build/binary_debug/src/bin error" ${CURRENT_STEP}
	sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_debug/src/bin" ${CURRENT_STEP}
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) #13
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "${COLOR_GREEN}Building binary_${TOS_MODE}${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ "${TOS_MODE}" == "release" ] 
    then
        cd /root/tos_build/binary_release || perror ${LINENO} "cd /root/tos_build/binary_release error" ${CURRENT_STEP}
        sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_release" ${CURRENT_STEP}
    else
        cd /root/tos_build/binary_debug || perror ${LINENO} "cd /root/tos_build/binary_debug error" ${CURRENT_STEP}
	sudo cmake --build . --target install -- -j${JOB_NUMBER} || perror ${LINENO} "make install error in /root/tos_build/binary_debug" ${CURRENT_STEP}
    fi
fi

if [ $architecture -eq 32 ]
then
    sudo ln -s -f /system/lib/i386-linux-gnu/libiconv/lib/libiconv.so /usr/lib/libiconv.so
    sudo ln -s -f /usr/lib/i386-linux-gnu/libexpat.a /usr/lib/libbsdxml.a
else
    sudo ln -s -f /system/lib/x86_64-linux-gnu/libiconv/lib/libiconv.so /usr/lib/libiconv.so
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) # 14
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then
    echo -e "{COLOR_RED}Installing ToGate${COLOR_NONE}"
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ $architecture -eq 32 ]
    then
        echo "ToGate를 서버로 부터 받아옵니다."
        sshpass -p ${DST_PASSWD} scp -P 12369 ${TOGATE_SERVER_PATH}:~/package/i386/ci_${TOGATE_VER}/ToGate.tai .
        if [ $? -eq 0 ]
        then
            echo "ToGate 버전 ${TOGATE_VER} 설치를 시작합니다"
            sudo tar -xvf ToGate.tai -C ${TOGATE_INSTALL_PATH} || perror "Installing ToGate Error" ${CURRENT_STEP}
            echo "ToGate 설치가 완료되었습니다."
        else
            echo "ToGate.tai 버전 ${TOGATE_VER}를 받아오는데 실패하였습니다."
            echo "해당 문제는 ToGate 서버접속에 문제일 수도 있고,"
            echo "TOS 버전과 동일한 ToGate가 아직 업로드되지 않아서 일수도 있습니다."
            echo "ssh togate@192.168.10.86 -p 12369 하여 최신 버전을 확인 후 scp로 받아주세요."
        fi

    else
        echo "ToGate를 서버로 부터 받아옵니다."
        sshpass -p ${DST_PASSWD} scp -P 12369 ${TOGATE_SERVER_PATH}:~/package/amd64/ci_${TOGATE_VER}/ToGate.tai .
        if [ $? -eq 0 ]
        then
            echo "ToGate 버전 ${TOGATE_VER} 설치를 시작합니다"
            sudo tar -xvf ToGate.tai -C ${TOGATE_INSTALL_PATH} || perror "Installing ToGate Error" ${CURRENT_STEP}
            echo "ToGate 설치가 완료되었습니다."
        else
            echo "ToGate.tai 버전 ${TOGATE_VER}를 받아오는데 실패하였습니다."
            echo "해당 문제는 ToGate 서버접속에 문제일 수도 있고,"
            echo "TOS 버전과 동일한 ToGate가 아직 업로드되지 않아서 일수도 있습니다."
            echo "ssh ${TOGATE_SERVER_PATH} -p 12369 하여 최신 버전을 확인 후 scp로 받아주세요."
        fi
    fi
fi

CURRENT_STEP=$((CURRENT_STEP + 1 )) # 15
if [ ${ERROR_NUM} -le ${CURRENT_STEP} ]; then 
    echo "${CURRENT_STEP}" > "${TOS_ERROR_FILE}"
    if [ ${ZONE_ON} == "ON" ]; then
        echo -e "${COLOR_RED}Refreshing Zone Configurations${COLOR_NONE}"
        cd /root/tos_build/binary_debug/src/boot/zone/bin || perror ${LINENO} "cd /root/tos_build/binary_debug/src/boot/zone/bin error" ${CURRENT_STEP}
        sudo make zone-refresh || perror ${LINENO} "sudo make zone-refresh error" ${CURRENT_STEP}
    fi
fi

check_desktop_folder()
{
    if [ ! -e /zone/normal/rootfs/home/${WHOAMI} ]; then
        mkdir /zone/normal/rootfs/home/${WHOAMI}
    fi

    sudo chown ${WHOAMI}:${WHOAMI} /zone/normal/rootfs/home/${WHOAMI}

    mkdir /zone/normal/rootfs/home/${WHOAMI}/Desktop
    sudo chown ${WHOAMI}:${WHOAMI} /zone/normal/rootfs/home/${WHOAMI}/Desktop
}

check_desktop_folder

sudo rm ${TOS_ERROR_FILE}

echo -e "\n${COLOR_GREEN}설치가 끝났습니다. sudo reboot을 실행시켜 주세요.${COLOR_NONE}"

exit 0
