#!/bin/sh

#  buid_framework
#  WDPackageUIKit
#
#  Created by acorld on 15/9/28.
#  Copyright (c) 2015年 koudai. All rights reserved.


echo "要打包的framework工程路径：$1"
echo "要打包的framework工程名称：$2"
echo "打包后的.framework目录：$3"
echo ".framework要移至哪个目录：$4"

#$1 FMK_NAME
#$2

# Sets the target folders and the final framework product.
WRK_DIR=$1
FMK_NAME=$2
FMK_VERSION=A
FMK_GOAL_DIR=$4
BUILD_DIR=${WRK_DIR}/build

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
PRODUCT_DIR=$3/Products
INSTALL_DIR=${PRODUCT_DIR}/${FMK_NAME}.framework

# Working dir will be deleted after the framework creation.



DEVICE_DIR=${BUILD_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${BUILD_DIR}/Release-iphonesimulator/${FMK_NAME}.framework


#cd Project Dir
cd ${WRK_DIR}
pwd

echo "_______START________"

# Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos clean
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator clean

echo "_______CLEAN FINISH________"

xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator

echo "_______BUILD FINISH________"

# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

# Creates and renews the final product folder.
mkdir -p "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}/Versions"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers"

# Creates the internal links.
# It MUST uses relative path, otherwise will not work when the folder is copied/moved.
ln -s "${FMK_VERSION}" "${INSTALL_DIR}/Versions/Current"
ln -s "Versions/Current/Headers" "${INSTALL_DIR}/Headers"
ln -s "Versions/Current/Resources" "${INSTALL_DIR}/Resources"
ln -s "Versions/Current/${FMK_NAME}" "${INSTALL_DIR}/${FMK_NAME}"

echo "${DEVICE_DIR}/Headers/"
echo "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers/"

# Copies the headers and resources files to the final product folder.
cp -R "${DEVICE_DIR}/Headers/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers/"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/"

# Removes the binary and header from the resources folder.
if [ -d "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/Headers" ]
then
rm -rf "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/Headers"
fi

if [ -d "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/${FMK_NAME}" ]
then
rm -rf "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/${FMK_NAME}"
fi

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/Versions/${FMK_VERSION}/${FMK_NAME}"


#判断FMK_NAME文件夹存在，存在删除里面的文件，否则创建
FMK_FILE_DIR=${FMK_NAME}_Files
if [ -d "${FMK_GOAL_DIR}/${FMK_FILE_DIR}" ]
then
#到指定目录删除指定类型文件
cd ${FMK_GOAL_DIR}/${FMK_FILE_DIR}/
find .  -name "*.framework" -exec rm -rf {} \;
find .  -name "*.bundle" -exec rm -rf {} \;
else
mkdir -p "${FMK_GOAL_DIR}/${FMK_FILE_DIR}"
fi

#将framework和bundle文件复制到目标目录
cp -R ${BUILD_DIR}/Release-iphoneos/*.bundle "${PRODUCT_DIR}/"
cp -R "${PRODUCT_DIR}/" "${FMK_GOAL_DIR}/${FMK_FILE_DIR}/"

#删除build文件夹
if [ -d "${BUILD_DIR}" ]
then
rm -rf "${BUILD_DIR}"
fi

#删除product文件夹
if [ -d "${PRODUCT_DIR}" ]
then
rm -rf "${PRODUCT_DIR}"
fi

#打开输出目录
echo "You will skip to dir:${FMK_GOAL_DIR}"
cd ${FMK_GOAL_DIR}/${FMK_FILE_DIR}
open ./

